import 'package:blood_donor/features/splashscreens/data/remote_splashscreen_datasource.dart';

class SplashscreenRepository {
  SplashscreenRepository._privateController();
  static final SplashscreenRepository _splashscreenRepository =
      SplashscreenRepository._privateController();
  factory SplashscreenRepository() {
    return _splashscreenRepository;
  }
  final RemoteSplashscreenDatasource _datasource =
      RemoteSplashscreenDatasource();

  Future<String?> getCurrentAppVersion() async {
    try {
      return await _datasource.getCurrentAppVersion();
    } catch (e) {
      rethrow;
    }
  }
}
