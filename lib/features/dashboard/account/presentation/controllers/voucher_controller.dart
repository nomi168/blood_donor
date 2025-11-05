import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/dashboard/account/data/models/voucher_model.dart';
import 'package:blood_donor/features/dashboard/account/domain/account_repository.dart';
import 'package:get/get.dart';

class VoucherController extends GetxController {
  AccountRepository _repository = AccountRepository();
  List<VoucherModel> voucherList = [];
  bool isLoading = false;

  @override
  void onInit() {
    getVouchersList();
    super.onInit();
  }

  Future<void> getVouchersList() async {
    voucherList.clear();
    isLoading = true;
    voucherList = await getVoucherHistory();
    isLoading = false;
    update();
  }

  Future<List<VoucherModel>> getVoucherHistory() async {
    try {
      return await _repository.getVoucherHistory();
    } catch (e) {
      Helper.handleError(e, 'Error while getting voucher data!');
      return [];
    }
  }
}
