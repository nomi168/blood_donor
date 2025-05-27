import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/dashboard/feeds/data/models/chat_request_model.dart';
import 'package:blood_donor/features/dashboard/feeds/presentation/controller/chat_request_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class ChatRequestScreen extends StatelessWidget {
  const ChatRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<ChatRequestController>(
        init: ChatRequestController(),
        builder: (controller) {
          return RefreshIndicator(
            color: Colors.red,
            onRefresh: () async {
              await controller.getChatRequestList();
            },
            child: controller.chatRequestList.isEmpty && !controller.isLoading
                ? Center(
                    child: Text(
                      "No data found",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 0.w, 5.w, 0),
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.chatRequestList.length,
                        itemBuilder: (context, index) {
                          if (controller.isLoading) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 160,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: ShapeDecoration(
                                  color: Colors.grey[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            ChatRequestModel chat =
                                controller.chatRequestList[index];
                            return CouponCard(
                              curveAxis: Axis.vertical,
                              firstChild: Container(
                                // alignment: Alignment.topLeft,
                                decoration: BoxDecoration(color: Colors.grey),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: chat.image!.isNotEmpty
                                          ? chat.image!
                                          : "https://www.lscthub.co.uk/wp-content/themes/u-design/assets/images/placeholders/event-placeholder.jpg",
                                      placeholder: (context, url) =>
                                          const CupertinoActivityIndicator(
                                        color: Colors.white,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                              secondChild: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black26,
                                ),
                                padding:
                                    const EdgeInsets.only(top: 0, left: 10),
                                child: Stack(
                                  children: [
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          // margin: const EdgeInsets.only(
                                          //     bottom: 1, right: 1),
                                          width: 50,
                                          height: 50,

                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 0),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(100),
                                            ),
                                          ),
                                        )),
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      margin: EdgeInsets.only(top: 40),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Column(
                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              chat.senderName!,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(height: 2),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Row(
                                          children: [
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                shape: WidgetStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    WidgetStateProperty
                                                        .all<Color>(const Color(
                                                            0xFFDE0A1E)),
                                              ),
                                              child: Text(
                                                'Reject',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                              onPressed: () async {
                                                await controller
                                                    .deleteChatRequest(
                                                        chat.senderEmail!);
                                                controller.chatRequestList
                                                    .removeAt(index);
                                                controller.update();
                                              },
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: ElevatedButton(
                                              style: ButtonStyle(
                                                shape: WidgetStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    WidgetStateProperty
                                                        .all<Color>(const Color(
                                                            0xFFDE0A1E)),
                                              ),
                                              child: Text(
                                                'Accept',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                              onPressed: () async {
                                                if (controller.chatRequestList
                                                        .length >
                                                    0) {
                                                  DateTime now = DateTime.now();
                                                  String formattedDate =
                                                      DateFormat('MM-dd-yyyy')
                                                          .format(now);
                                                  String formattedTime =
                                                      DateFormat('h:mm a')
                                                          .format(now);
                                                  dynamic payload = {
                                                    'id': '',
                                                    'taker_id': chat.receiverId,
                                                    'taker_number':
                                                        chat.recipientNumber,
                                                    'taker_email':
                                                        chat.recipientEmail,
                                                    'taker_image':
                                                        chat.receiverImage,
                                                    'taker_name': chat.name,
                                                    'date': formattedDate,
                                                    'time': formattedTime,
                                                    'donor_id': chat.senderId,
                                                    'donor_number':
                                                        chat.senderNumber,
                                                    'donor_email':
                                                        chat.senderEmail,
                                                    'donor_name':
                                                        chat.senderName,
                                                    'donor_image': chat.image,
                                                  };
                                                  bool result = await controller
                                                      .acceptChatRequest(
                                                          payload);
                                                  if (result) {
                                                    await controller
                                                        .updateChatRequest(chat
                                                            .recipientEmail!);
                                                    controller.chatRequestList
                                                        .removeAt(index);
                                                    controller.update();
                                                  }
                                                } else {
                                                  logError(
                                                      'Invalid index: $index');
                                                }
                                              },
                                            ))
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5,
                          mainAxisExtent: 120,
                        ),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
//  Widget RequestButton() {
//     // getChatRequestData();
//     if (chatrequestData.isEmpty) {
//       return Center(child: CircularProgressIndicator());
//     } else if (chatrequestData.isEmpty) {
//       return Center(child: Text('No chat requests available'));
//     } else {
//       return 
//     }
//   }