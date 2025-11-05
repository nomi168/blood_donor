import 'dart:developer';

import 'package:blood_donor/core/utils/services/notification_storage.dart';
import 'package:blood_donor/features/dashboard/notifications/data/model/notificationModel.dart';
import 'package:blood_donor/features/dashboard/notifications/presentation/constroller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TabBar(
              padding: const EdgeInsets.only(right: 130),
              splashBorderRadius: BorderRadius.circular(10),
              splashFactory: NoSplash.splashFactory,
              dividerColor: Colors.black12,
              dividerHeight: 0,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color(0x0fdf0600).withValues(alpha: 0.18),
              ),
              tabs: [
                Tab(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "All",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "Unread",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15),
              child: const Divider(
                height: 1.2,
                thickness: 0.8,
                color: Colors.black26,
              ),
            ),
            const Expanded(
              child: TabBarView(children: [
                AllNotification(),
                UnreadNotification(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class AllNotification extends StatefulWidget {
  const AllNotification({super.key});

  @override
  State<AllNotification> createState() => _AllNotificationState();
}

class _AllNotificationState extends State<AllNotification>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    loadNotifications();
    super.initState();
  }

  Future<void> loadNotifications() async {
    NotificationsProvider.to.loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: GetBuilder<NotificationsProvider>(builder: (cont) {
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              if (cont.notifications.isEmpty)
                Expanded(
                    child: Center(
                        child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 150),
                      child: SvgPicture.asset(
                          'images/Notification/No Notification.svg'),
                    ),
                    const Text(
                      'No notifications',
                    ),
                  ],
                ))),
              if (cont.notifications.isNotEmpty)
                Expanded(
                  child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: cont.notifications.length,
                        itemBuilder: (context, index) {
                          //     " " +
                          //     notifications[index].read.toString());
                          NotificationModel notificationModel =
                              cont.notifications[index];
                          log("Notification Type ${notificationModel.notificationType}");
                          return Container(
                            height: 10.h,
                            margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: notificationModel.read
                                  ? Colors.white
                                  : const Color.fromARGB(255, 235, 233, 233)
                                      .withValues(alpha: 0.9),
                            ),
                            child: Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.startToEnd,
                              onDismissed: (direction) async {
                                await NotificationStorage.removeNotification(
                                    index);
                                setState(() {
                                  cont.notifications.remove(notificationModel);
                                });
                              },
                              background: Container(
                                alignment: Alignment.centerLeft,
                                color: Colors.red,
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  if (!notificationModel.read) {
                                    await NotificationStorage.markAsRead(index);
                                    setState(() {
                                      notificationModel.read = true;
                                    });
                                  }
                                  NotificationsProvider.to.loadNotifications();

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return showNotificationDetails(
                                          notificationModel, context);
                                    },
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 60,
                                        width: 60,
                                        child: Container(
                                            height: 80.h,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300
                                                  .withValues(alpha: 0.9),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: SvgPicture.asset(
                                              "images/Notification/Orders.svg",
                                              width: 25,
                                              height: 25,
                                            )),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 3),
                                            child: Text(notificationModel.title,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black)),
                                          ),
                                          Expanded(
                                              child: Text(
                                            notificationModel.content,
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          )),
                                          Row(
                                            children: [
                                              Text(
                                                  DateFormat('dd/MM/yyyy')
                                                      .format(notificationModel
                                                          .timeSpan!),
                                                  style:
                                                      TextStyle(fontSize: 9)),
                                              Container(
                                                width: 15,
                                                alignment: Alignment.center,
                                                child: const Text("•"),
                                              ),
                                              Text(
                                                  DateFormat('hh:mm a').format(
                                                      notificationModel
                                                          .timeSpan!),
                                                  style:
                                                      TextStyle(fontSize: 9)),
                                            ],
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                ),
            ],
          );
        }),
      ),
    );
  }
}

AlertDialog showNotificationDetails(
    NotificationModel notificationModel, BuildContext context) {
  return AlertDialog(
    title: Text(
      notificationModel.title,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          notificationModel.content,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          "${DateFormat('dd/MM/yyyy').format(notificationModel.timeSpan!)} at ${DateFormat('hh:mm a').format(notificationModel.timeSpan!)}",
          style: TextStyle(
            fontSize: 10,
            color: Colors.black,
          ),
        ),
      ],
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          "Close",
          style: TextStyle(color: Colors.black),
        ),
      ),
    ],
  );
}

class UnreadNotification extends StatefulWidget {
  const UnreadNotification({super.key});

  @override
  State<UnreadNotification> createState() => _UnreadNotificationState();
}

class _UnreadNotificationState extends State<UnreadNotification>
    with SingleTickerProviderStateMixin {
  List<NotificationModel> notifications = [];
  bool isview = false;

  @override
  void initState() {
    loadNotifications();
    // markAllRead();
    super.initState();

    //loadNotifications();
  }

  // Future<void> loadNotifications() async {
  //   NotificationsProvider.to.loadNotifications();
  // }

  Future<void> loadNotifications() async {
    List<NotificationModel> loadedNotifications =
        await NotificationStorage.loadNotifications();
    notifications = loadedNotifications;
    // notifications.sort(((a, b) => a.timeSpan!.isBefore(b.timeSpan!) ? 1 : 0));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: GetBuilder<NotificationsProvider>(
          builder: (controller) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                if (notifications.isEmpty)
                  Expanded(
                      child: Center(
                          child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 150),
                        child: SvgPicture.asset(
                            'images/Notification/No Notification.svg'),
                      ),
                      const Text(
                        'No notifications',
                      ),
                    ],
                  ))),
                if (notifications.isNotEmpty)
                  Expanded(
                    child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            log(notifications.length.toString());
                            NotificationModel notificationModel =
                                notifications[index];
                            if (notificationModel.read) {
                              return const SizedBox.shrink();
                            }

                            return Container(
                              height: 10.h,
                              margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                // border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(10.0),
                                color: notificationModel.read
                                    ? Colors.white
                                    : const Color.fromARGB(255, 235, 233, 233)
                                        .withValues(alpha: 0.9),
                              ),
                              child: Dismissible(
                                key: UniqueKey(),
                                direction: DismissDirection.startToEnd,
                                onDismissed: (direction) async {
                                  await NotificationStorage.removeNotification(
                                      index);
                                  setState(() {
                                    notifications.remove(notificationModel);
                                  });
                                },
                                background: Container(
                                  alignment: Alignment.centerLeft,
                                  color: Colors.black,
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    if (!notificationModel.read) {
                                      await NotificationStorage.markAsRead(
                                          index);
                                      setState(() {
                                        notificationModel.read = true;
                                      });
                                    }
                                    NotificationsProvider.to
                                        .loadNotifications();

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return showNotificationDetails(
                                            notificationModel, context);
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 60,
                                          width: 60,
                                          child: Container(
                                              height: 80.h,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300
                                                    .withValues(alpha: 0.9),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              child: SvgPicture.asset(
                                                "images/Notification/Orders.svg",
                                                width: 25,
                                                height: 25,
                                              )),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin:
                                                  const EdgeInsets.only(top: 3),
                                              child: Text(
                                                  notificationModel.title,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black)),
                                            ),
                                            Expanded(
                                                child: Text(
                                              notificationModel.content,
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black),
                                            )),
                                            Row(
                                              children: [
                                                Text(
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(
                                                            notificationModel
                                                                .timeSpan!),
                                                    style:
                                                        TextStyle(fontSize: 9)),
                                                Container(
                                                  width: 15,
                                                  alignment: Alignment.center,
                                                  child: const Text("•"),
                                                ),
                                                Text(
                                                    DateFormat('hh:mm a')
                                                        .format(
                                                            notificationModel
                                                                .timeSpan!),
                                                    style:
                                                        TextStyle(fontSize: 9)),
                                              ],
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
