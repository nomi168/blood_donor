import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RemoteSplashscreenDatasource {
  RemoteSplashscreenDatasource._privateController();
  static final RemoteSplashscreenDatasource _remoteSplashscreenDatasource =
      RemoteSplashscreenDatasource._privateController();
  factory RemoteSplashscreenDatasource() {
    return _remoteSplashscreenDatasource;
  }

  Future<String?> getCurrentAppVersion() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('app_version').get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        return doc['version_code'];
      } else {
        logError('No banner data found!');
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
