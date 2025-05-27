import 'dart:convert';

import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/Main%20Screen/notifications/data/model/notificationModel.dart';
import 'package:blood_donor/features/dashboard/Main%20Screen/notifications/presentation/constroller/notification_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationStorage {
  static late SharedPreferences preferences;
  static Future<void> initializeNotificationsStorage1() async {
    preferences = await SharedPreferences.getInstance();
  }

  static clearNotifications() async {
    await preferences.remove(notificationKey);
  }

  static String get notificationKey =>
      "NOTIFICATIONS_KEY_${UserController.to.userModel!.email}";
  static removeNotification(int index) async {
    List<NotificationModel> notifications = await loadNotifications();
    if (index >= 0 && index < notifications.length) {
      notifications.removeAt(index);
      List<String> stringItems = [];
      for (var element in notifications) {
        stringItems.insert(0, jsonEncode(element.toJson()));
      }
      await preferences.setStringList(notificationKey, stringItems);
    }
    await loadNotifications();
  }

  static List<NotificationModel> notificationsData = [];

  static Future<List<NotificationModel>> loadNotifications() async {
    await preferences.reload();
    preferences = await SharedPreferences.getInstance();

    List<NotificationModel> notifications = [];
    var data = preferences.getStringList(notificationKey);
    if (data != null) {
      for (var element in data) {
        notifications.add(NotificationModel.fromJson(jsonDecode(element)));
      }
    }
    notificationsData = notifications;
    notifications.sort(((a, b) => a.timeSpan!.isBefore(b.timeSpan!) ? 1 : 0));

    return notifications;
  }

  static markAsRead(int index) async {
    List<NotificationModel> notifications = await loadNotifications();
    notifications[index].read = true;

    List<String> stringItems = [];
    for (var element in notifications) {
      stringItems.add(jsonEncode(element.toJson()));
    }
    await preferences.setStringList(notificationKey, stringItems);
    notifications = await loadNotifications();
    NotificationsProvider.to.loadNotifications();
  }

  static Future pushNewNotification(NotificationModel notificationModel) async {
    try {
      // await getCustomerId();
      List<NotificationModel> notifications = await loadNotifications();
      int lastLength = notifications.length;

      // log("Post Notification Length: ${notifications.length}");
      // log(notificationModel.notificationType.toString());
      notificationModel.timeSpan = DateTime.now();
      notifications.add(notificationModel);
      List<String> stringItems = [];
      for (var element in notifications) {
        stringItems.insert(0, jsonEncode(element.toJson()));
      }
      await preferences.setStringList(notificationKey, stringItems);
      notifications = await loadNotifications();
      logSuccess("Post Notification Length: ${notifications.length}");

      return lastLength != notifications.length;
    } catch (e) {
      return false;
    }
  }
}
