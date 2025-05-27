import 'package:blood_donor/Services/notification_storage.dart';
import 'package:blood_donor/features/dashboard/Main%20Screen/notifications/data/model/notificationModel.dart';
import 'package:get/get.dart';

class NotificationsProvider extends GetxController {
  List<NotificationModel> _notifications = [];
  static NotificationsProvider get to => Get.find();
  List<NotificationModel> get notifications => _notifications;

  // Function to load and sort notifications
  Future<void> loadNotifications() async {
    try {
      // Load the notifications from storage
      List<NotificationModel> loadedNotifications =
          await NotificationStorage.loadNotifications();

      // Sort notifications by timeSpan in descending order
      loadedNotifications.sort((a, b) => b.timeSpan!.compareTo(a.timeSpan!));

      // Update the notifications list and notify listeners
      _notifications = loadedNotifications;
      update();
    } catch (error) {
      // Handle any errors here
      print('Error loading notifications: $error');
    }
  }

  // Function to add a new notification
  void addNotification(NotificationModel notification) {
    _notifications.add(notification);
    update();
  }

  // Function to remove a notification by its ID
  void removeNotification(String id) {
    _notifications.removeWhere((notification) => notification.id == id);
    update();
  }

  void clearNotifications() {
    _notifications.clear();

    update();
  }
}
