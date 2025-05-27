import 'package:blood_donor/features/dashboard/menus/data/datasource/remote_menu_setting_datasource.dart';
import 'package:blood_donor/features/dashboard/menus/data/models/terms_condition_model.dart';

class TermConditionRepository {
  TermConditionRepository._privateController();
  static final TermConditionRepository _conditionRepository =
      TermConditionRepository._privateController();
  factory TermConditionRepository() {
    return _conditionRepository;
  }
  final RemoteMenuSettingDatasource _datasource = RemoteMenuSettingDatasource();

  Future<TermsConditionModel?> getTermsConditiong(String userId) async {
    try {
      return await _datasource.getTermsCondition(userId);
    } catch (e) {
      rethrow;
    }
  }
}
