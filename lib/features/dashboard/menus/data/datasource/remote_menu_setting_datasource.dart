import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/dashboard/menus/data/models/admin_terms_condition_model.dart';
import 'package:blood_donor/features/dashboard/menus/data/models/faqs_model.dart';
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

  Future<List<FaqModel>> getFaqsData() async {
    try {
      List<FaqModel> faqList = [];
      QuerySnapshot chatQuerySnapshot =
          await FirebaseFirestore.instance.collection('faqs').get();

      if (chatQuerySnapshot.docs.isNotEmpty) {
        for (var doc in chatQuerySnapshot.docs) {
          faqList.add(FaqModel.fromJson((doc.data() as Map<String, dynamic>)));
        }
      } else {
        logError('data not found!');
      }
      return faqList;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getPrivacyPolicy() async {
    try {
      QuerySnapshot chatQuerySnapshot = await FirebaseFirestore.instance
          .collection('admin_privacy_policy')
          .get();

      if (chatQuerySnapshot.docs.isNotEmpty) {
        String privacy_policy =
            chatQuerySnapshot.docs.first.get('privacy_policty');
        return privacy_policy;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AdminTermsconditionModel?> getAdminTermsConditionData() async {
    try {
      QuerySnapshot chatQuerySnapshot = await FirebaseFirestore.instance
          .collection('admin_terms_condition')
          .get();

      if (chatQuerySnapshot.docs.isNotEmpty) {
        final data =
            chatQuerySnapshot.docs.first.data() as Map<String, dynamic>;
        return AdminTermsconditionModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
