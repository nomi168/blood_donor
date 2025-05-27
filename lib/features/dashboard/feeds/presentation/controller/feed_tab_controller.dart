import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/dashboard/feeds/domain/feed_repository.dart';
import 'package:get/get.dart';

class FeedTabController extends GetxController {
  final FeedRepository _feedRepository = FeedRepository();
  int index = 1;
  @override
  void onInit() {
    super.onInit();
    // updateAppStatus();
  }

  Future<void> updateAppStatus(bool status) async {
    try {
      return await _feedRepository.updateAppStatus(status);
    } catch (e) {
      Helper.handleError(e, 'Error while checking app status!');
    }
  }
}
