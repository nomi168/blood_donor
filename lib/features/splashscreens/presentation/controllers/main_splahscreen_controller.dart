import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/dashboard.dart';
import 'package:blood_donor/features/splashscreens/domain/splashscreen_repository.dart';
import 'package:blood_donor/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MainSplahscreenController extends GetxController {
  final SplashscreenRepository _repository = SplashscreenRepository();
  String? newAppVersion;
  String appVersion = "";
  PackageInfo? packageInfo;

  @override
  void onInit() {
    super.onInit();
    getAppVersion();
  }

  Future<void> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appVersion = "${packageInfo.version}";
    update();
    await getNewAppVersion();

    if (appVersion == newAppVersion) {
      navigateAfterDelay();
    } else {
      showUpdateDialog(navigatorKey.currentContext!);
    }
  }

  Future<void> getNewAppVersion() async {
    newAppVersion = null;
    newAppVersion = await getCurrentAppVersion();
    update();
  }

  void openPlayStore() async {
    const playStoreUrl =
        'https://play.google.com/store/apps/details?id=com.pakistan.Ebloodpakistan';

    final uri = Uri.parse(playStoreUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.system_update,
                size: 60,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              const Text(
                'Update Required',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Your app version is outdated.\nPlease update the app to continue using all features.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              /// 🔘 Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Optional: close app
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Exit',style: TextStyle(color: Colors.black),),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        openPlayStore();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void navigateAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const Dashboard();
          },
          transitionDuration: const Duration(microseconds: 100),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(10.0, 0.0); // slide in from the right
            const end = Offset.zero;
            const curve = Curves.easeInOutQuart;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      );
    });
  }

  Future<String?> getCurrentAppVersion() async {
    try {
      return await _repository.getCurrentAppVersion();
    } catch (e) {
      Helper.handleError(e, 'Error while getting app version!');
      return null;
    }
  }
}
