// ignore_for_file: use_key_in_widget_constructors

import 'dart:developer';

import 'package:blood_donor/core/utils/services/notification_storage.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/notifications/data/model/notificationModel.dart';
import 'package:blood_donor/features/dashboard/notifications/presentation/constroller/notification_controller.dart';
import 'package:blood_donor/features/dashboard/notifications/presentation/enum/notification_enum.dart';
import 'package:blood_donor/features/dashboard/notifications/presentation/screens/notification_screen.dart';
import 'package:blood_donor/features/dashboard/feeds/presentation/screens/notification.dart';
import 'package:blood_donor/features/splashscreens/presentation/screens/splash_screen.dart';
import 'package:blood_donor/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/splashscreens/main_splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

bool isFromNotification = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userUid = prefs.getString('user_uid');
  if (userUid != null && userUid.isNotEmpty) {
    await Get.put(UserController(), permanent: true);
  }

  NotificationStorage.initializeNotificationsStorage1();
  Get.put(NotificationsProvider(), permanent: true);
  NotificationServices.requestNotificationPermission();
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  FirebaseMessaging.instance.getInitialMessage().then((val) async {
    if (val != null) {
      isFromNotification = true;
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((val) async {
    log("on Message opened.............................");

    handleMessage();
  });
  FirebaseMessaging.onMessage.listen((event) async {
    log("on Message.............................");
    log("Foreground notification");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await NotificationStorage.initializeNotificationsStorage1();
    await NotificationServices().showNotification(event);
    NotificationType? notificationType;
    log("Event is ${event.data["type"]}");

    switch (event.data["type"]) {
      case 'request_notification':
        notificationType = NotificationType.order;
        break;
      case 'accept_notification':
        notificationType = NotificationType.promotion;
        break;

      default:
        break;
    }
    if (event.data['type'] != "chat") {
      await NotificationStorage.pushNewNotification(NotificationModel(
          id: 12,
          notificationType: notificationType ?? NotificationType.order,
          title: event.notification!.title ?? "",
          content: event.notification!.body ?? ""));
    }

    await NotificationsProvider.to.loadNotifications();
  });
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Set the status bar color
    // statusBarBrightness: Brightness.light, // For iOS
    statusBarIconBrightness: Brightness.dark, // For Android
    // systemNavigationBarColor: Colors.blue, // Set the navigation bar color
    systemNavigationBarIconBrightness: Brightness.dark, // For Android
  ));

  runApp(MyApp(userUid: userUid));
}

@pragma('vm:entry-point')
Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  log("on Bankground handler.............................");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationStorage.initializeNotificationsStorage1();

  NotificationType? notificationType;
  switch (message.data['type']) {
    case 'request_notification':
      notificationType = NotificationType.order;
      break;
    case 'accept_notification':
      notificationType = NotificationType.promotion;
      break;

    // Add more cases as needed
    default:
      break;
  }

  if (message.data['type'] != "chat") {
    await NotificationStorage.pushNewNotification(NotificationModel(
        id: 12,
        notificationType: notificationType ?? NotificationType.order,
        title: message.notification!.title ?? "",
        content: message.notification!.body ?? ""));
  }
}

bool isBottomSheetOpen = false;
Future<void> handleMessage() async {
  if (!isBottomSheetOpen) {
    isBottomSheetOpen = true;

    BuildContext? context = navigatorKey.currentContext;

    if (context != null) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      showBarModalBottomSheet(
        animationCurve: Curves.easeInBack,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        context: context,
        builder: (context) {
          return const NotificationScreen(); // Your Notifications widget
        },
      ).whenComplete(() {
        isBottomSheetOpen = false;
      });
    } else {
      debugPrint("⚠️ navigatorKey.currentContext is null");
    }
  }
}

class MyApp extends StatelessWidget {
  final String? userUid;
  // ignore: prefer_const_constructors_in_immutables
  MyApp({required this.userUid});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: userUid != null ? const MainSplash() : SplashScreen(),
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return GetMaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          home: child,
          // home: userUid != null ? const MainSplash() : SplashScreen(),
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
