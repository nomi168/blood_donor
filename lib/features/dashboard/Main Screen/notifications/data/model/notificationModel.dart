import 'package:blood_donor/features/dashboard/Main%20Screen/notifications/presentation/enum/notification_enum.dart';

class NotificationModel {
  late int id = 0;
  late NotificationType notificationType;
  late String title;
  late String content;
  int? orderId;
  DateTime? timeSpan;
  bool read = false;

  NotificationModel(
      {required this.notificationType,
      required this.id,
      required this.title,
      required this.content,
      this.orderId,
      this.timeSpan});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    switch (json['notificationType']) {
      case 'cart':
        notificationType = NotificationType.cart;
        break;
      case 'order':
        notificationType = NotificationType.order;
        break;
      case 'orderStatus':
        notificationType = NotificationType.orderStatus;
        break;
      case 'setting':
        notificationType = NotificationType.setting;
        break;
      case 'profile':
        notificationType = NotificationType.profile;
        break;
      case 'news':
        notificationType = NotificationType.news;
        break;
      case 'promotion':
        notificationType = NotificationType.promotion;
        break;
      default:
    }
    title = json['title'];
    content = json['content'];
    orderId = json['orderId'];
    read = json['read'];
    timeSpan = DateTime.parse(json['timeSpan']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notificationType'] = notificationType.name;
    data['title'] = title;
    data['content'] = content;
    data['orderId'] = orderId;
    data['read'] = read;
    data['timeSpan'] = timeSpan.toString();
    return data;
  }
}
