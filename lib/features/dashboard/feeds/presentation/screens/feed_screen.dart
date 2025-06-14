import 'package:blood_donor/constants.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/feeds/data/models/feed_taker_model.dart';
import 'package:blood_donor/features/dashboard/feeds/presentation/controller/feed_controller.dart';
import 'package:blood_donor/features/dashboard/feeds/presentation/screens/map_on_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<FeedController>(
        init: FeedController(),
        builder: (controller) {
          return RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: () async {
                await controller.getTakerData();
              },
              child: controller.takerList.isEmpty && !controller.isLoading
                  ? Center(
                      child: Text(
                        "No data found",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.fromLTRB(5.w, 0.w, 5.w, 0),
                      width: double.infinity,
                      child: ListView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.isLoading
                            ? 6
                            : controller.takerList.length,
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
                            FeedTakerModel taker = controller.takerList[index];
                            return Container(
                              width: double.infinity,
                              height: 250,
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color:
                                    Colors.white, // Optional: Background color
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 0.5, color: Color(0xFFDDDDDD)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey
                                                .withValues(alpha: 0.1),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(06),
                                        border: Border.all(
                                            color: Colors.grey.shade300)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 70,
                                          height: 70,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: taker.image!.isNotEmpty
                                                  ? taker.image!
                                                  : "https://www.lscthub.co.uk/wp-content/themes/u-design/assets/images/placeholders/event-placeholder.jpg",
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
                                        const SizedBox(width: 10),
                                        Container(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                taker.name!,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    CupertinoIcons.calendar,
                                                    size: 15,
                                                    color: Colors.black45,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    taker.date!,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black45),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    CupertinoIcons.clock,
                                                    size: 15,
                                                    color: Colors.black45,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    taker.time!,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black45),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Spacer(),
                                        InkWell(
                                          splashFactory: NoSplash.splashFactory,
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  _buildAnimatedPopup(
                                                      context, taker.note!),
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(top: 30),
                                            padding: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                    color: PRIMARY_COLOR)),
                                            child: Icon(
                                              Icons.info,
                                              color: Colors.red,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    height: 0.5,
                                    color: Colors.black45,
                                    thickness: 0.5,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey
                                                  .withValues(alpha: 0.1),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(06),
                                          border: Border.all(
                                              color: Colors.grey.shade300)),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.pin_drop,
                                            color: Colors.black54,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Location',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black54),
                                              ),
                                              Text(
                                                taker.location!,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                'blood-type: ${taker.blood}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                                color: taker.situation ==
                                                        'critical'
                                                    ? Colors.red
                                                    : Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(06)),
                                            child: Text(
                                              taker.situation!,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          dynamic payload = {
                                            'sender_id':
                                                UserController.to.userModel!.id,
                                            'senderEmail': UserController
                                                .to.userModel!.email,
                                            'senderName':
                                                '${UserController.to.userModel!.firstname} ${UserController.to.userModel!.lastname}',
                                            'senderNumber': UserController
                                                .to.userModel!.phonenumber,
                                            'recipientEmail': taker.email,
                                            'recipientNumber': taker.number,
                                            'receiverimage': taker.image,
                                            'receiver_id': taker.takerId,
                                            'name': taker.name,
                                            'image': UserController
                                                .to.userModel!.image,
                                            'status': 'pending',
                                            'timestamp':
                                                FieldValue.serverTimestamp(),
                                          };

                                          if (UserController
                                                  .to.userModel!.type ==
                                              'donor') {
                                            bool result = await controller
                                                .sendChatRequest(payload);
                                            if (result) {
                                              controller.sendNotification(
                                                  payload['recipientEmail']);
                                            }
                                          } else {
                                            showCustomSnackBar(
                                                context,
                                                'only donors are allowed to send chat requests!',
                                                false);
                                          }
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 140,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: PRIMARY_COLOR,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                              color: Colors.red,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Text(
                                            'Friend Request',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          if (UserController
                                                  .to.userModel!.type ==
                                              'donor') {
                                            if (controller.isAvailability ==
                                                true) {
                                              showCustomSnackBar(
                                                  context,
                                                  'You have already donated blood. Please wait 90 days before donating again.',
                                                  false);
                                            } else {
                                              final user =
                                                  UserController.to.userModel!;

                                              final feedController =
                                                  FeedController.to;

                                              dynamic payload = {
                                                'id': '',
                                                'takerid': taker.takerId,
                                                'fullname': taker.name,
                                                'image': taker.image,
                                                'email': taker.email,
                                                'hospitalname':
                                                    taker.hospitalName,
                                                'date': taker.date,
                                                'time': taker.time,
                                                'location': taker.location,
                                                'note': taker.note,
                                                'blood': taker.blood,
                                                'unit': taker.unit,
                                                'phone_number': taker.number,
                                                'situation': taker.situation,
                                                'bloodtype': taker.bloodType,
                                                'donor_name':
                                                    '${user.firstname} ${user.lastname}',
                                                'donor_email': user.email,
                                                'donor_number':
                                                    user.phonenumber,
                                                'donor_image': user.image,
                                                'donor_blood': user.bloodgroup,
                                                'received_status': false,
                                                'status': false,
                                                'taker_received_status': false
                                              };
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(
                                                PageRouteBuilder(
                                                  pageBuilder: (context,
                                                      animation,
                                                      secondaryAnimation) {
                                                    return MapOnDonator(
                                                      payload: payload,
                                                      mapController:
                                                          feedController
                                                              .controllers,
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
                                              // );
                                            }
                                          } else {
                                            showCustomSnackBar(
                                                context,
                                                'Takers are not blood donors.',
                                                false);
                                          }
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 140,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: PRIMARY_COLOR,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                              color: Colors.red,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Text(
                                            'Donate Now',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }
                        },
                      )));
        },
      ),
    );
  }

  Widget _buildAnimatedPopup(BuildContext context, String note) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: 300,
        height: 200,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Note",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              note,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red),
                textStyle: WidgetStateProperty.all(
                  TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
