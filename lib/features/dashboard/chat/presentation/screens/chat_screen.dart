import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/chat/data/models/chat_accept_model.dart';
import 'package:blood_donor/features/dashboard/chat/presentation/controllers/chat_controller.dart';
import 'package:blood_donor/features/dashboard/chat/presentation/screens/message_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<ChatController>(
          init: ChatController(),
          builder: (chatController) {
            return Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(0.w, 0.h, 0, 0),
                      child: Text(
                        'Inbox',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      )),
                  chatController.chatList.isEmpty &&
                          chatController.isLoading == true
                      ? Column(
                        children: [
                          SizedBox(height: 40.h,),
                          SizedBox(
                              // height: 60.h,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: PRIMARY_COLOR,
                                  strokeWidth: 4,
                                ),
                              ),
                            ),
                        ],
                      )
                      : chatController.chatList.isEmpty
                          ? Column(
                            children: [
                              SizedBox(height: 40.h,),
                              Center(
                                  child: Text(
                                    'No Person in Inbox',
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                  ),
                                ),
                            ],
                          )
                          : Expanded(
                              child: UserController.to.userModel!.type ==
                                      'donor'
                                  ? ListView.builder(
                                      itemCount: chatController.chatList.length,
                                      itemBuilder: (context, index) {
                                        ChatAcceptModel chat =
                                            chatController.chatList[index];
                                        return Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.black12,
                                                  border: Border.all(
                                                      color: Colors.black12),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          05)),
                                              child: ListTile(
                                                onTap: () {
                                                  // String sender_id =
                                                  //     chat.sender_id;
                                                  // String receiver_id =
                                                  //     chat.receiver_id;
                                                  // String image = chat.image;
                                                  // String name = chat.name;
                                                  // String sendemail =
                                                  //     chat.senderemail;
                                                  // String receiveremail =
                                                  //     chat.receiveremail;
                                                  // String senderimage =
                                                  //     chat.senderimage;
                                                  // String accept_number =
                                                  //     chat.accept_number;

                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .push(
                                                    PageRouteBuilder(
                                                      pageBuilder: (context,
                                                          animation,
                                                          secondaryAnimation) {
                                                        return MessageScreen(
                                                          chatModel: chat,

                                                          // senderPhoneNumber: chat.,
                                                        );
                                                      },
                                                      transitionDuration:
                                                          const Duration(
                                                              seconds: 1),
                                                      transitionsBuilder:
                                                          (context,
                                                              animation,
                                                              secondaryAnimation,
                                                              child) {
                                                        const begin = Offset(
                                                            10.0,
                                                            0.0); // slide in from the right
                                                        const end = Offset.zero;
                                                        const curve = Curves
                                                            .easeInOutQuart;

                                                        var tween = Tween(
                                                                begin: begin,
                                                                end: end)
                                                            .chain(CurveTween(
                                                                curve: curve));
                                                        var offsetAnimation =
                                                            animation
                                                                .drive(tween);

                                                        return SlideTransition(
                                                          position:
                                                              offsetAnimation,
                                                          child: child,
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Container(
                                                    height: 45,
                                                    width: 45,
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl: chat.takerImage,
                                                      placeholder: (context,
                                                              url) =>
                                                          const CupertinoActivityIndicator(
                                                        color: Colors.white,
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),

                                                title: Text(chat.takerName),
                                                // subtitle: Text(chat['message']),
                                                trailing: Text(chat.time),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  : ListView.builder(
                                      itemCount: chatController.chatList.length,
                                      itemBuilder: (context, index) {
                                        final chat =
                                            chatController.chatList[index];
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.black12,
                                              border: Border.all(
                                                  color: Colors.black12),
                                              borderRadius:
                                                  BorderRadius.circular(05)),
                                          child: ListTile(
                                            onTap: () {
                                              // String sender_id = chat.sender_id;
                                              // String receiver_id = chat.receiver_id;
                                              // String image = chat.image;
                                              // String name = chat.acceptname;
                                              // String sendemail = chat.senderemail;
                                              // String receiveremail = chat.receiveremail;
                                              // String senderimage = chat.senderimage;
                                              // String accept_number = chat.accept_number;
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(
                                                PageRouteBuilder(
                                                  pageBuilder: (context,
                                                      animation,
                                                      secondaryAnimation) {
                                                    return MessageScreen(
                                                      chatModel: chat,
                                                    );
                                                  },
                                                  transitionDuration:
                                                      const Duration(
                                                          microseconds: 100),
                                                  transitionsBuilder: (context,
                                                      animation,
                                                      secondaryAnimation,
                                                      child) {
                                                    const begin = Offset(10.0,
                                                        0.0); // slide in from the right
                                                    const end = Offset.zero;
                                                    const curve =
                                                        Curves.easeInOutQuart;

                                                    var tween = Tween(
                                                            begin: begin,
                                                            end: end)
                                                        .chain(CurveTween(
                                                            curve: curve));
                                                    var offsetAnimation =
                                                        animation.drive(tween);

                                                    return SlideTransition(
                                                      position: offsetAnimation,
                                                      child: child,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Container(
                                                height: 45,
                                                width: 45,
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl: chat.donorImage,
                                                  placeholder: (context, url) =>
                                                      const CupertinoActivityIndicator(
                                                    color: Colors.white,
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                            title: Text(chat.donorName),
                                            // subtitle: Text(chat['message']),
                                            trailing: Text(chat.time),
                                          ),
                                        );
                                      },
                                    )),
                ]);
          },
        ),
      ),
    );
  }
}
