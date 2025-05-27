import 'package:blood_donor/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/dashboard/account/domain/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ManageAddressController extends GetxController {
  final AccountRepository _accountRepository = AccountRepository();
  TextEditingController home = TextEditingController();
  TextEditingController work = TextEditingController();
  TextEditingController travel = TextEditingController();
  bool isFormVisible = true;

  Future<bool> addHomeAddress(dynamic payload) async {
    try {
      showLoader('adding address...');
      return await _accountRepository.addHomeAddress(payload);
    } catch (e) {
      Helper.handleError(e, 'Error while adding home address!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<bool> addWorkAddress(dynamic payload) async {
    try {
      showLoader('adding address...');
      return await _accountRepository.addWorkAddress(payload);
    } catch (e) {
      Helper.handleError(e, 'Error while adding work address!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<bool> addTravelAddress(dynamic payload) async {
    try {
      showLoader('adding address...');
      return await _accountRepository.addTravelAddress(payload);
    } catch (e) {
      Helper.handleError(e, 'Error while adding travel address!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }
}
