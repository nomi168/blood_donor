import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/dashboard/menus/domain/term_condition_repository.dart';
import 'package:get/get.dart';

class PrivacyPolicyController extends GetxController {
  final TermConditionRepository _repository = TermConditionRepository();
  String privacy_policy = '';
  bool isLoading = false;


  @override
void onInit() {
  getPrivacyPolicyData();
  super.onInit();
}




  Future<void> getPrivacyPolicyData() async {
    isLoading = true;
    privacy_policy = '';

    privacy_policy = (await getPrivacyPolicy())!;
    isLoading = false;
    update();
  }

  Future<String?> getPrivacyPolicy() async {
    try {
      return await _repository.getPrivacyPolicy();
    } catch (e) {
      Helper.handleError(e, 'Error while getting privacy policy!');
      return null;
    }
  }
}
