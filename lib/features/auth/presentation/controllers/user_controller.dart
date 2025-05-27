import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/auth/data/models/user_model.dart';
import 'package:blood_donor/features/auth/domain/auth_repository.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  static UserController get to => Get.find();

  UserModel? userModel;

  @override
  void onInit() {
    getUserData();
    super.onInit();
  }

  Future<void> getUserData() async {
    userModel = await getUserDataByEmail();
    update();
  }

  Future<UserModel?> getUserDataByEmail() async {
    try {
      return await _authRepository.getUserDataByEmail();
    } catch (e) {
      Helper.handleError(e, 'Error while getting user data!');
      return null;
    }
  }

  Future<void> updateAppStatus(bool isActive) async {
    try {
      return await _authRepository.updateAppStatus(isActive);
    } catch (e) {
      Helper.handleError(e, 'Error while updating app status!');
    }
  }
}
