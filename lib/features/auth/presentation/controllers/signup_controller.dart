import 'dart:io';

import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/auth/domain/auth_repository.dart';
import 'package:blood_donor/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class SignupController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController conpassword = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController fname = TextEditingController();

  TextEditingController lname = TextEditingController();
  List<String> nomi = ['Male', 'Female'];
  String selectedIndex = '';
  List<String> nomi1 = ['A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-', 'AB-'];
  String selectedIndex1 = '';
  late final phone;
  bool obscureText = false;
  bool obscureText1 = false;
  final hasNumber = RegExp(r'[0-9]');
  final hasSpecialChar = RegExp(r'[!@#\$&*~%^()_+\-=\[\]{};:\\|,.<>\/?]');

  File? image;

  Future<void> getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final fileSize = await File(pickedFile.path).length();
      const maxFileSize = 1 * 1024 * 1024; // 1MB in bytes

      if (fileSize > maxFileSize) {
        final compressedFile = await _compressImage(File(pickedFile.path));
        final compressedFileSize = await compressedFile.length();

        if (compressedFileSize > maxFileSize) {
          _showFileSizeExceededMessage();
        } else {
          image = compressedFile;
          update();
        }
      } else {
        image = File(pickedFile.path);
        update();
      }
    } else {
      print('No image selected.');
    }
    Navigator.pop(navigatorKey.currentContext!);
  }

  Future<File> _compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = path.join(dir.absolute.path, 'temp.jpg');

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80,
    );

    while ((await result!.length()) > 1 * 1024 * 1024) {
      result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 70, // Adjust quality parameter to further reduce file size
      );
    }
    // log(result.path);
    return File(result.path);
  }

  void _showFileSizeExceededMessage() {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text('File size exceeds 1MB.'),
      ),
    );
  }

  Future<void> showPickerOptions(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () => getImage(ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () => getImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> checkEmail(String email) async {
    try {
      showLoader('checking email');
      return await _authRepository.checkEmail(email);
    } catch (e) {
      Helper.handleError(e, "Error while checking email!");
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }
}
