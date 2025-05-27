import 'dart:async';

import 'package:blood_donor/common/widgets/custon_snakbar.dart';
import 'package:blood_donor/core/theme/app_colors.dart';
import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Helper {
  static void handleError(dynamic e, String errorMessage) {
    if (e is TypeError) {
      showCustomSnackBar(navigatorKey.currentContext!,
          message: errorMessage, color: backgroundColorError);
    } else if (e is FirebaseAuthException) {
      showCustomSnackBar(navigatorKey.currentContext!,
          message: "${e.message ?? errorMessage}!",
          color: backgroundColorError);
    } else if (e is FirebaseException) {
      showCustomSnackBar(navigatorKey.currentContext!,
          message: "${e.message ?? errorMessage}!",
          color: backgroundColorError);
    } else if (e is TimeoutException) {
      showCustomSnackBar(navigatorKey.currentContext!,
          message: "Request timeout, please try again in few seconds!",
          color: backgroundColorError);
    } else {
      showCustomSnackBar(navigatorKey.currentContext!,
          message: "$e!", color: backgroundColorError);
    }

    logError(e.toString());
  }
}
