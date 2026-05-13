import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/auth/domain/auth_repository.dart';
import 'package:cnic_scanner/cnic_scanner.dart';
import 'package:cnic_scanner/model/cnic_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CardScanningController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  TextEditingController nameTEController = TextEditingController();
  TextEditingController cnicTEController = TextEditingController();
  TextEditingController dobTEController = TextEditingController();
  TextEditingController doiTEController = TextEditingController();
  TextEditingController doeTEController = TextEditingController();
  bool correctcnic = false;

  CnicModel _cnicModel = CnicModel();

  Future<void> scanCnic(ImageSource imageSource) async {
    /// you will need to pass one argument of "ImageSource" as shown here
    CnicModel cnicModel =
        await CnicScanner().scanImage(imageSource: imageSource);

    _cnicModel = cnicModel;
    nameTEController.text = _cnicModel.cnicHolderName;
    cnicTEController.text = _cnicModel.cnicNumber;
    dobTEController.text = _cnicModel.cnicHolderDateOfBirth;
    doiTEController.text = _cnicModel.cnicIssueDate;
    doeTEController.text = _cnicModel.cnicExpiryDate;

    update();
  }

  bool isEligible({
    required String dob,
    required String doi,
  }) {
    final DateFormat formatter = DateFormat("dd/MM/yyyy");

    DateTime dateOfBirth = formatter.parse(dob);
    DateTime dateOfIssue = formatter.parse(doi);

    int age = dateOfIssue.year - dateOfBirth.year;

    if (dateOfIssue.month < dateOfBirth.month ||
        (dateOfIssue.month == dateOfBirth.month &&
            dateOfIssue.day < dateOfBirth.day)) {
      age--;
    }

    return age >= 18;
  }

  void showNotEligibleDialog({
    required String userType,
  }) {
    Get.defaultDialog(
      title: "Not Eligible",
      titleStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      content: Column(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 15),
          Text(
            userType == "donor"
                ? "You are not eligible to donate blood"
                : "You are not eligible to take blood",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ],
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          Get.back();
          Get.back();
        },
        child: const Text(
          "OK",
          style: TextStyle(color: Colors.white),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<bool> checkingCNIC(String cnic) async {
    try {
      showLoader('checking cnic...');
      return await _authRepository.checkingCNIC(cnic);
    } catch (e) {
      Helper.handleError(e, 'Error while checking cnic!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<bool> addCnicCardDetail(dynamic payload) async {
    try {
      showLoader('adding cnic...');
      return await _authRepository.addCnicCardDetail(payload);
    } catch (e) {
      Helper.handleError(e, 'Error while adding cnic!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }
}
