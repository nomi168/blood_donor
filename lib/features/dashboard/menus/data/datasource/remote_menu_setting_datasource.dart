import 'package:blood_donor/features/dashboard/menus/data/models/terms_condition_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RemoteMenuSettingDatasource {
  RemoteMenuSettingDatasource._privateController();
  static final RemoteMenuSettingDatasource _datasource =
      RemoteMenuSettingDatasource._privateController();
  factory RemoteMenuSettingDatasource() {
    return _datasource;
  }

  Future<TermsConditionModel?> getTermsCondition(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('terms_condition')
          .where('user_id', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        return TermsConditionModel.fromJson(
            userDoc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
