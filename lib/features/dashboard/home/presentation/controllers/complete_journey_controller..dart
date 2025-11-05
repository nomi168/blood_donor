import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/dashboard/home/domain/home_repository.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class CompleteJourneyController extends GetxController {
  final HomeRepository _homeRepository = HomeRepository();
  Future<bool> addDonorHistory(dynamic payload) async {
    try {
      showLoader('updating...');
      return await _homeRepository.addDonorHistory(payload);
    } catch (e) {
      Helper.handleError(e, 'Error while adding donor history!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> updateDonorStatus(String takerId, String donorId) async {
    try {
      return await _homeRepository.updateDonorStatus(takerId, donorId);
    } catch (e) {
      Helper.handleError(e, 'Error while updating status!');
    }
  }

  Future<void> addOrUpdateAvailableDonor() async {
    try {
      return await _homeRepository.addOrUpdateAvailableDonor();
    } catch (e) {
      Helper.handleError(e, 'Error while updating donor!');
    }
  }

  Future<void> updateTakerStatus(String id) async {
    try {
      return await _homeRepository.updateTakerStatus(id);
    } catch (e) {
      Helper.handleError(e, 'Error while updating taker status!');
    }
  }

  Future<int?> getDonorBloodCount() async {
    try {
      return await _homeRepository.getDonorBloodCount();
    } catch (e) {
      Helper.handleError(e, 'Error while getting donor blood count!');
      return null;
    }
  }

  Future<void> updateDonorBloodCount(int count) async {
    try {
      return await _homeRepository.updateDonorBloodCount(count);
    } catch (e) {
      Helper.handleError(e, 'Error while udating donor blood count!');
    }
  }
}
