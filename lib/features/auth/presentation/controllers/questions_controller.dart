import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/auth/domain/auth_repository.dart';
import 'package:blood_donor/features/dashboard/feeds/presentation/screens/notification.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class QuestionsController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  NotificationServices notificationServices = NotificationServices();
  String Q1 = '';
  String Q2 = '';
  String Q3 = '';
  String Q4 = '';
  String Q5 = '';
  String Q6 = '';
  String type1 = '';
  Map<String, dynamic> payload = {};

  String token = '';
  String picture1 = '';
  String user_id = '';
  bool privacy_process = false;
  bool terms = false;
  bool flag = false;
  bool isUrdu = false;
  String type = '';
  @override
  void onInit() {
    getNotificationToken();
    super.onInit();
  }

  Future<void> getNotificationToken() async {
    String token1 = await notificationServices.getDeviceToken();
    token = token1;
    update();
  }

  Future<bool> addUser(Map<String,dynamic> payload, {bool flag = false}) async {
    try {
      showLoader('adding user...');
      return await _authRepository.addUser(payload);
    } catch (e) {
      Helper.handleError(e, 'Error while adding user!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> usereligible(String id, {bool flag = false}) async {
    try {
      return await _authRepository.usereligible(id);
    } catch (e) {
      Helper.handleError(e, 'Error while checking user eligible!');
    }
  }

  Future<void> userAddLocation(String id, String name, String location) async {
    try {
      return await _authRepository.userAddLocation(id, name, location);
    } catch (e) {
      Helper.handleError(e, 'Error while adding current location!');
    }
  }
}
