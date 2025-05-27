import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/chat/data/models/chat_accept_model.dart';
import 'package:blood_donor/features/dashboard/chat/presentation/controllers/message_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'hero_screen.dart';

class MessageScreen extends StatefulWidget {
  final ChatAcceptModel chatModel;
  const MessageScreen({super.key, required this.chatModel});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      logSuccess("My State is $state");
      UserController.to.updateAppStatus(false);
    } else if (state == AppLifecycleState.resumed) {
      logSuccess("My State is $state");
      UserController.to.updateAppStatus(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessageController>(
      init: MessageController(payload: widget.chatModel),
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.lightGreen.shade100.withValues(alpha: 0.3),
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HeroScreen(
                            image: UserController.to.userModel!.type == 'donor'
                                ? widget.chatModel.takerImage
                                : widget.chatModel.donorImage),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'profile-image',
                    child: Material(
                      color: Colors.transparent,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            UserController.to.userModel!.type == 'donor'
                                ? widget.chatModel.takerImage
                                : widget.chatModel.donorImage),
                        radius: 20,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(4.w, 0, 0, 0),
                        child: Text(
                          UserController.to.userModel!.type == 'donor'
                              ? widget.chatModel.takerName
                              : widget.chatModel.donorName,
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        )),
                    StreamBuilder<bool>(
                      stream: controller.getOnlineOffline(
                          widget.chatModel.donorEmail,
                          widget.chatModel.takerEmail),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          controller.useractive = snapshot.data!;
                        }
                        return Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 15),
                          child: Text(
                            controller.useractive ? 'Online' : 'Offline',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Spacer(),
                InkWell(
                  splashColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  onTap: () {
                    controller.openWhatsApp(
                        UserController.to.userModel!.type == 'donor'
                            ? widget.chatModel.takerNumber
                            : widget.chatModel.donorNumber);
                  },
                  child: Image.network(
                      height: 20,
                      width: 20,
                      'https://cdn-icons-png.freepik.com/256/15707/15707917.png?semt=ais_hybrid'),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  child: StreamBuilder<QuerySnapshot>(
                    key: UniqueKey(),
                    stream: controller.getMessagesList(
                        widget.chatModel.donorId, widget.chatModel.takerId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No messages'));
                      }

                      List<Map<String, dynamic>> messages = snapshot.data!.docs
                          .map((doc) => doc.data() as Map<String, dynamic>)
                          .where((data) =>
                              data.containsKey('index') &&
                              data['index'] != null)
                          .toList()
                        ..sort((a, b) => a['index'].compareTo(b['index']));

                      List<Widget> messageWidgets = buildMessagesList(messages);

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (controller.scrollController.hasClients) {
                          controller.scrollController.jumpTo(controller
                              .scrollController.position.maxScrollExtent);
                        }
                      });
                      return ListView(
                        controller: controller.scrollController,
                        children: messageWidgets,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.message,
                        decoration: InputDecoration(
                          hintText: 'Enter your message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                        ),
                        onChanged: (text) {
                          final previousSelection =
                              controller.message.selection;
                          controller.message.text = text;
                          controller.message.selection = previousSelection;
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () async {
                        if (controller.message.text.isNotEmpty) {
                          controller.latestMessageId =
                              await controller.getLatestMessageID();
                          // // Format the timestamp as a string
                          String formattedDateTime =
                              DateFormat('dd-MM-yyyy h.mm a')
                                  .format(controller.now);
                          controller.latestMessageId++;
                          dynamic payload = {
                            'sender_email':
                                UserController.to.userModel!.type == 'donor'
                                    ? widget.chatModel.takerEmail
                                    : widget.chatModel.donorEmail,
                            'receiver_email':
                                UserController.to.userModel!.type == 'donor'
                                    ? widget.chatModel.donorEmail
                                    : widget.chatModel.takerEmail,
                            'sender_id': widget.chatModel.donorId,
                            'receiver_id': widget.chatModel.takerId,
                            'content': controller.message.text.trim(),
                            'time': formattedDateTime,
                            'index': controller.latestMessageId
                          };
                          await controller.sendMessage(payload);

                          controller.message.clear();

                          await controller.sendNotificationsToUser(
                              UserController.to.userModel!.type == 'donor'
                                  ? widget.chatModel.takerEmail
                                  : widget.chatModel.donorEmail);

                          // if (UserController.to.userModel!.type == 'taker') {
                          //   controller.latestMessageId++;

                          //   await sendMessage(
                          //     widget.sender_id,
                          //     widget.receiver_id,
                          //     userEmail1,
                          //     widget.sendemail,
                          //     _controller.text,
                          //   );
                          //   _controller.clear();
                          //   await sendNotificationsToUser(widget.sendemail);
                          // }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> buildMessagesList(List<Map<String, dynamic>> dataList) {
    // Sort the messages by time (with seconds)

    dataList.sort((a, b) {
      try {
        DateTime timeA = DateFormat('h:mm:ss a').parse(a['time']);
        DateTime timeB = DateFormat('h:mm:ss a').parse(b['time']);
        return timeA.compareTo(timeB);
      } catch (e) {
        logError('Error parsing time: ${e.toString()}');
        return 0;
      }
    });

    return dataList.map((data) => buildMessage(data)).toList();
  }

  Widget buildMessage(Map<String, dynamic> data) {
    bool isMe = data['receiver_email'] == UserController.to.userModel!.email;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            isMe == false
                ? UserController.to.userModel!.type == 'taker'
                    ? Material(
                        color: Colors.transparent,
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.chatModel.takerImage),
                          radius: 20,
                        ))
                    : Material(
                        color: Colors.transparent,
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.chatModel.donorImage),
                          radius: 20,
                        ))
                : SizedBox(),
            SizedBox(width: 5),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: isMe ? Colors.red : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        data['content'],
                        style: TextStyle(
                            fontSize: 16,
                            color: isMe ? Colors.white : Colors.black),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        data['time'] != null
                            ? (data['time'])
                            : 'Time not available',
                        style: TextStyle(
                          fontSize: 10,
                          color: isMe ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            isMe == true
                ? UserController.to.userModel!.type == 'donor'
                    ? Material(
                        color: Colors.transparent,
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.chatModel.takerImage),
                          radius: 20,
                        ))
                    : Material(
                        color: Colors.transparent,
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.chatModel.donorImage),
                          radius: 20,
                        ))
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
