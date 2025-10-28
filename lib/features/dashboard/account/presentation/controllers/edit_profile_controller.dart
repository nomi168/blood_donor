import 'dart:io';

import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/auth/data/models/user_model.dart';
import 'package:blood_donor/features/dashboard/account/domain/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  final UserModel payload;
  EditProfileController({required this.payload});

  final AccountRepository _accountRepository = AccountRepository();
  TextEditingController location = TextEditingController();
  TextEditingController fname = TextEditingController();

  TextEditingController lname = TextEditingController();

  List<String> bloodGroup = ['A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-', 'AB-'];
  String selectedBloodGroup = '';
  File? image;

  @override
  void onInit() {
    fname.text = payload.firstname;
    lname.text = payload.lastname;
    location.text = payload.location;
    selectedBloodGroup = payload.bloodgroup;

    super.onInit();
  }

  Future<void> getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      update();
    } else {
      logError('No image selected.');
    }
  }

  Future<UserModel?> updateProfile(Map<String, dynamic> payload) async {
    try {
      showLoader('updating profile...');
      return await _accountRepository.updateProfile(payload);
    } catch (e) {
      Helper.handleError(e, 'Error while updating profile!');
      return null;
    } finally {
      await EasyLoading.dismiss();
    }
  }
}
