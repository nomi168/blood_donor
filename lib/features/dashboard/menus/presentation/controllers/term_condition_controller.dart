import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/menus/data/models/admin_terms_condition_model.dart';
import 'package:blood_donor/features/dashboard/menus/data/models/terms_condition_model.dart';
import 'package:blood_donor/features/dashboard/menus/domain/term_condition_repository.dart';
import 'package:get/get.dart';

class TermConditionController extends GetxController {
  final TermConditionRepository _repository = TermConditionRepository();
  AdminTermsconditionModel? adminTermsconditionModel;

  TermsConditionModel? termsConditionModel;
  @override
  void onInit() {
    getTermsAndConditions();
    getAdminTermsCondition();
    super.onInit();
  }

  Future<void> getTermsAndConditions() async {
    termsConditionModel =
        await getTermsCondition(UserController.to.userModel!.id);
    update();
  }

  Future<void> getAdminTermsCondition() async {
    adminTermsconditionModel = await getAdminTermsConditionData();

    update();
  }

  Future<TermsConditionModel?> getTermsCondition(String userId) async {
    try {
      return await _repository.getTermsConditiong(userId);
    } catch (e) {
      Helper.handleError(e, 'Error while getting terms & conditions!');
      return null;
    }
  }

  Future<AdminTermsconditionModel?> getAdminTermsConditionData() async {
    try {
      return await _repository.getAdminTermsConditionData();
    } catch (e) {
      Helper.handleError(e, 'Error while getting terms and condition!');
      return null;
    }
  }
}
