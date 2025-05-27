import 'package:blood_donor/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/auth/domain/auth_repository.dart';
import 'package:cnic_scanner/cnic_scanner.dart';
import 'package:cnic_scanner/model/cnic_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
