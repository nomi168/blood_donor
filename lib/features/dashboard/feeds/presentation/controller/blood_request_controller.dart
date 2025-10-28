import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/dashboard/feeds/data/models/feed_taker_model.dart';
import 'package:blood_donor/features/dashboard/feeds/domain/feed_repository.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class BloodRequestController extends GetxController {
  final FeedRepository _feedRepository = FeedRepository();
  List<FeedTakerModel> takerList = [];
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    getTakerData();
  }

  Future<void> getTakerData() async {
    takerList.clear();
    isLoading = true;
    update();

    takerList = await getTakerList();

    takerList.sort((a, b) {
      if (a.status == false && b.status == true) return -1; // a first
      if (a.status == true && b.status == false) return 1; // b first
      return 0; // otherwise keep order
    });

    isLoading = false;
    update();
  }

  Future<void> getTakerRefreshData() async {
    takerList.clear();
    isLoading = true;
    update();

    takerList = await getTakerList();

    // ✅ Sort so that status == false comes first
    takerList.sort((a, b) {
      if (a.status == false && b.status == true) return -1; // a first
      if (a.status == true && b.status == false) return 1; // b first
      return 0; // otherwise keep order
    });

    isLoading = false;
    update();
  }

  Future<List<FeedTakerModel>> getTakerList() async {
    try {
      return await _feedRepository.getTakerList();
    } catch (e) {
      Helper.handleError(e, 'Error while getting taker data!');
      return [];
    }
  }

  Future<bool> deleteBloodRequest(bool isActive) async {
    try {
      showLoader('deleting request...');
      return await _feedRepository.deleteBloodRequest(isActive);
    } catch (e) {
      Helper.handleError(e, 'Error while deleting blood request data!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }
}
