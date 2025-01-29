// ignore_for_file: use_key_in_widget_constructors

import 'package:blood_donor/Provider/FirebaseAuth.dart';
import 'package:blood_donor/Provider/Page.dart';
import 'package:blood_donor/Provider/Profile.dart';
import 'package:blood_donor/Provider/RewardPoints.dart';
import 'package:blood_donor/Screens/Splash%20Screen/SplashScreen.dart';
import 'package:blood_donor/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/Splash Screen/MainSplash.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  await FirebaseAppCheck.instance.activate();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Received notification: ${message.notification?.title}");
    print("Notification body: ${message.notification?.body}");
    // Handle the received notification
  });
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Set the status bar color
    // statusBarBrightness: Brightness.light, // For iOS
    statusBarIconBrightness: Brightness.dark, // For Android
    // systemNavigationBarColor: Colors.blue, // Set the navigation bar color
    systemNavigationBarIconBrightness: Brightness.dark, // For Android
  ));
  FirebaseMessaging.onBackgroundMessage(_fireaseMessagingBackgroundHandler);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userUid = prefs.getString('user_uid');

  runApp(MyApp(userUid: userUid));
}

@pragma('vm:entry-point')
Future<void> _fireaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  print(message.notification!.title.toString());
}

class MyApp extends StatelessWidget {
  final String? userUid;
  // ignore: prefer_const_constructors_in_immutables
  MyApp({required this.userUid});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MyPageProvider()),
        ChangeNotifierProvider(create: (_) => Profile()),
        ChangeNotifierProvider(create: (_) => RewardPoints()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: userUid != null ? const MainSplash() : SplashScreen(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
