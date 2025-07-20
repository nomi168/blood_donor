import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/account/data/models/history_model.dart';
import 'package:blood_donor/features/dashboard/account/domain/account_repository.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final AccountRepository _accountRepository = AccountRepository();
  List<BloodHistoryModel> historyList = [];
  bool isLoading = false;

  @override
  void onInit() {
    getHistoryData();
    super.onInit();
  }

  Future<void> getHistoryData() async {
    isLoading = true;

    historyList = await getHistoryList(
      UserController.to.userModel!.email,
      UserController.to.userModel!.type,
    );
    isLoading = false;

    update();
  }

  Future<List<BloodHistoryModel>> getHistoryList(
      String email, String type) async {
    try {
      return await _accountRepository.getHistoryList(email, type);
    } catch (e) {
      Helper.handleError(e, 'Error while getiing history list!');
      return [];
    }
  }
}
