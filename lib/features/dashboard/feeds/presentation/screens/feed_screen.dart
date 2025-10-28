import 'package:blood_donor/common/widgets/search_widget.dart';
import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/feeds/data/models/feed_taker_model.dart';
import 'package:blood_donor/features/dashboard/feeds/presentation/controller/feed_controller.dart';
import 'package:blood_donor/features/dashboard/feeds/presentation/screens/map_on_screen.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/dashboatd.dart';
import 'package:blood_donor/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
              color: PRIMARY_COLOR,
              onRefresh: () async {
                await controller.getTakerData();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SearchBarWidget(
                      searchController: controller.searchController,
                      onChanged: (query) {
                        controller.filterUsers(query);
                        controller.update();
                      },
                    ),
                    controller.takerList.isEmpty && !controller.isLoading
                        ? Center(
                            child: Text(
                              "No data found",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.fromLTRB(10, 0.w, 10, 0),
                            width: double.infinity,
                            child: ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.isLoading
                                  ? 6
                                  : controller.filterList.isEmpty
                                      ? controller.takerList.length
                                      : controller.filterList.length,
                              itemBuilder: (context, index) {
                                if (controller.isLoading) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 180,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      decoration: ShapeDecoration(
                                        color: Colors.grey[300],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  FeedTakerModel taker =
                                      controller.filterList.isEmpty
                                          ? controller.takerList[index]
                                          : controller.filterList[index];
                                  Map<String, dynamic> payload = {
                                    "senderEmail": taker.email,
                                    "recipientEmail":
                                        UserController.to.userModel!.email,
                                  };
                                  return FutureBuilder<bool>(
                                      future: controller.checkChatBox(payload),
                                      builder: (context, snapshot) {
                                        bool canChat = snapshot.data ?? false;
                                        return Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 250,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                color: Colors
                                                    .white, // Optional: Background color
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    width: 0.5,
                                                    color: Color(0xFFDDDDDD)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withValues(alpha: 0.1),
                                                    blurRadius: 10,
                                                    offset: Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                            vertical: 5),
                                                    decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withValues(
                                                                    alpha: 0.1),
                                                            spreadRadius: 2,
                                                            blurRadius: 5,
                                                            offset:
                                                                Offset(0, 3),
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(06),
                                                        border: Border.all(
                                                            color: Colors.grey
                                                                .shade300)),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: 70,
                                                          height: 70,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child:
                                                                CachedNetworkImage(
                                                              fit: BoxFit.cover,
                                                              imageUrl: taker
                                                                      .image!
                                                                      .isNotEmpty
                                                                  ? taker.image!
                                                                  : "https://www.lscthub.co.uk/wp-content/themes/u-design/assets/images/placeholders/event-placeholder.jpg",
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const CupertinoActivityIndicator(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Icon(Icons
                                                                      .error),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Container(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                taker.name!,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              const SizedBox(
                                                                  height: 4),
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    CupertinoIcons
                                                                        .calendar,
                                                                    size: 15,
                                                                    color: Colors
                                                                        .black45,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    taker.date!,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        color: Colors
                                                                            .black45),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    CupertinoIcons
                                                                        .clock,
                                                                    size: 15,
                                                                    color: Colors
                                                                        .black45,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    taker.time!,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        color: Colors
                                                                            .black45),
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
                                                          splashFactory: NoSplash
                                                              .splashFactory,
                                                          splashColor: Colors
                                                              .transparent,
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  _buildAnimatedPopup(
                                                                      context,
                                                                      taker
                                                                          .note!),
                                                            );
                                                          },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 30),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    1),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                border: Border.all(
                                                                    color:
                                                                        PRIMARY_COLOR)),
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
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5,
                                                              vertical: 2),
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withValues(
                                                                      alpha:
                                                                          0.1),
                                                              spreadRadius: 2,
                                                              blurRadius: 5,
                                                              offset:
                                                                  Offset(0, 3),
                                                            ),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(06),
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade300)),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.pin_drop,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Location',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                              Text(
                                                                taker.location !=
                                                                        null
                                                                    ? (taker.location!.characters.length >
                                                                            20
                                                                        ? '${taker.location!.characters.take(20)}...'
                                                                        : taker
                                                                            .location!)
                                                                    : '',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black54,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              Text(
                                                                'blood-type: ${taker.blood}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black54,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        5),
                                                            decoration: BoxDecoration(
                                                                color: taker.situation ==
                                                                        'critical'
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .blue,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            06)),
                                                            child: Text(
                                                              taker.situation!,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
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
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting)
                                                        const Center(
                                                            child:
                                                                CupertinoActivityIndicator(
                                                                    radius: 10))
                                                      else if (canChat)
                                                        ElevatedButton.icon(
                                                          icon: Icon(
                                                            FontAwesomeIcons
                                                                .message,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ),
                                                          label: const Text(
                                                            "Chat",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .redAccent,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            final dashboardState =
                                                                context.findAncestorStateOfType<
                                                                    DashboardState>();
                                                            dashboardState
                                                                ?.navigateToChatTab();
                                                          },
                                                        )
                                                      else if (!canChat)
                                                        InkWell(
                                                          onTap: () async {
                                                            Map<String, dynamic>
                                                                payload = {
                                                              'sender_id':
                                                                  UserController
                                                                      .to
                                                                      .userModel!
                                                                      .id,
                                                              'senderEmail':
                                                                  UserController
                                                                      .to
                                                                      .userModel!
                                                                      .email,
                                                              'senderName':
                                                                  '${UserController.to.userModel!.firstname} ${UserController.to.userModel!.lastname}',
                                                              'senderNumber':
                                                                  UserController
                                                                      .to
                                                                      .userModel!
                                                                      .phonenumber,
                                                              'recipientEmail':
                                                                  taker.email,
                                                              'recipientNumber':
                                                                  taker.number,
                                                              'receiverimage':
                                                                  taker.image,
                                                              'receiver_id':
                                                                  taker.takerId,
                                                              'name':
                                                                  taker.name,
                                                              'image':
                                                                  UserController
                                                                      .to
                                                                      .userModel!
                                                                      .image,
                                                              'status':
                                                                  'pending',
                                                              'timestamp':
                                                                  FieldValue
                                                                      .serverTimestamp(),
                                                            };

                                                            if (UserController
                                                                    .to
                                                                    .userModel!
                                                                    .type ==
                                                                'donor') {
                                                              bool result =
                                                                  await controller
                                                                      .sendChatRequest(
                                                                          payload);
                                                              if (result) {
                                                                controller
                                                                    .sendNotification(
                                                                        payload[
                                                                            'recipientEmail']);
                                                              }
                                                            } else {
                                                              Get.snackbar(
                                                                "Error",
                                                                "only donors are allowed to send chat requests.",
                                                                snackPosition:
                                                                    SnackPosition
                                                                        .TOP,
                                                                snackStyle:
                                                                    SnackStyle
                                                                        .FLOATING,
                                                                backgroundColor: Colors
                                                                    .red
                                                                    .withValues(
                                                                        alpha:
                                                                            0.9),
                                                                colorText:
                                                                    Colors
                                                                        .white,
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                                borderRadius: 8,
                                                                icon: Icon(
                                                                    Icons.error,
                                                                    color: Colors
                                                                        .white),
                                                              );
                                                            }
                                                          },
                                                          child: Container(
                                                            height: 40,
                                                            width: 140,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.blue,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 1.0,
                                                              ),
                                                            ),
                                                            child: Text(
                                                              'Chat Request',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          if (UserController
                                                                  .to
                                                                  .userModel!
                                                                  .bloodgroup !=
                                                              taker.blood) {
                                                            Get.snackbar(
                                                              "Info",
                                                              "You cannot donate blood because your blood group is ${UserController.to.userModel!.bloodgroup} while the blood request requires ${taker.blood}.",
                                                              snackPosition:
                                                                  SnackPosition
                                                                      .TOP,
                                                              snackStyle:
                                                                  SnackStyle
                                                                      .FLOATING,
                                                              backgroundColor: Colors
                                                                  .blue
                                                                  .withValues(
                                                                      alpha:
                                                                          0.9),
                                                              colorText:
                                                                  Colors.white,
                                                              margin: EdgeInsets
                                                                  .all(10),
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          3),
                                                              borderRadius: 8,
                                                              icon: Icon(
                                                                  Icons.info,
                                                                  color: Colors
                                                                      .white),
                                                            );
                                                          } else {
                                                            bool result = await controller
                                                                .checkUserCnicVerification(
                                                                    UserController
                                                                        .to
                                                                        .userModel!
                                                                        .email);
                                                            if (result) {
                                                              if (UserController
                                                                      .to
                                                                      .userModel!
                                                                      .type ==
                                                                  'donor') {
                                                                if (controller
                                                                        .isAvailability ==
                                                                    true) {
                                                                  Get.snackbar(
                                                                    "Error",
                                                                    "You have already donated blood. Please wait 90 days before donating again.",
                                                                    snackPosition:
                                                                        SnackPosition
                                                                            .TOP,
                                                                    snackStyle:
                                                                        SnackStyle
                                                                            .FLOATING,
                                                                    backgroundColor: Colors
                                                                        .red
                                                                        .withValues(
                                                                            alpha:
                                                                                0.9),
                                                                    colorText:
                                                                        Colors
                                                                            .white,
                                                                    margin: EdgeInsets
                                                                        .all(
                                                                            10),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            3),
                                                                    borderRadius:
                                                                        8,
                                                                    icon: Icon(
                                                                        Icons
                                                                            .error,
                                                                        color: Colors
                                                                            .white),
                                                                  );
                                                                } else {
                                                                  final user =
                                                                      UserController
                                                                          .to
                                                                          .userModel!;

                                                                  final feedController =
                                                                      FeedController
                                                                          .to;

                                                                  Map<String,
                                                                          dynamic>
                                                                      payload =
                                                                      {
                                                                    'id': '',
                                                                    'takerid': taker
                                                                        .takerId,
                                                                    'fullname':
                                                                        taker
                                                                            .name,
                                                                    'image': taker
                                                                        .image,
                                                                    'email': taker
                                                                        .email,
                                                                    'hospitalname':
                                                                        taker
                                                                            .hospitalName,
                                                                    'date': taker
                                                                        .date,
                                                                    'time': taker
                                                                        .time,
                                                                    'location':
                                                                        taker
                                                                            .location,
                                                                    'note': taker
                                                                        .note,
                                                                    'blood': taker
                                                                        .blood,
                                                                    'blood_image':
                                                                        taker
                                                                            .bloodImage,
                                                                    'unit': taker
                                                                        .unit,
                                                                    'phone_number':
                                                                        taker
                                                                            .number,
                                                                    'situation':
                                                                        taker
                                                                            .situation,
                                                                    'bloodtype':
                                                                        taker
                                                                            .bloodType,
                                                                    'donor_name':
                                                                        '${user.firstname} ${user.lastname}',
                                                                    'donor_email':
                                                                        user.email,
                                                                    'donor_number':
                                                                        user.phonenumber,
                                                                    'donor_image':
                                                                        user.image,
                                                                    'donor_blood':
                                                                        user.bloodgroup,
                                                                    'received_status':
                                                                        false,
                                                                    'status':
                                                                        false,
                                                                    'taker_received_status':
                                                                        false,
                                                                    'is_delete':
                                                                        false
                                                                  };
                                                                  Navigator.of(
                                                                          context,
                                                                          rootNavigator:
                                                                              true)
                                                                      .push(
                                                                    PageRouteBuilder(
                                                                      pageBuilder: (context,
                                                                          animation,
                                                                          secondaryAnimation) {
                                                                        return MapOnDonator(
                                                                          payload:
                                                                              payload,
                                                                          mapController:
                                                                              feedController.controllers,
                                                                        );
                                                                      },
                                                                      transitionDuration:
                                                                          const Duration(
                                                                              microseconds: 100),
                                                                      transitionsBuilder: (context,
                                                                          animation,
                                                                          secondaryAnimation,
                                                                          child) {
                                                                        const begin = Offset(
                                                                            10.0,
                                                                            0.0); // slide in from the right
                                                                        const end =
                                                                            Offset.zero;
                                                                        const curve =
                                                                            Curves.easeInOutQuart;

                                                                        var tween =
                                                                            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                                                        var offsetAnimation =
                                                                            animation.drive(tween);

                                                                        return SlideTransition(
                                                                          position:
                                                                              offsetAnimation,
                                                                          child:
                                                                              child,
                                                                        );
                                                                      },
                                                                    ),
                                                                  );
                                                                  // );
                                                                }
                                                              } else {
                                                                Get.snackbar(
                                                                  "Error",
                                                                  "Takers are not blood donors.",
                                                                  snackPosition:
                                                                      SnackPosition
                                                                          .TOP,
                                                                  snackStyle:
                                                                      SnackStyle
                                                                          .FLOATING,
                                                                  backgroundColor: Colors
                                                                      .red
                                                                      .withValues(
                                                                          alpha:
                                                                              0.9),
                                                                  colorText:
                                                                      Colors
                                                                          .white,
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              3),
                                                                  borderRadius:
                                                                      8,
                                                                  icon: Icon(
                                                                      Icons
                                                                          .error,
                                                                      color: Colors
                                                                          .white),
                                                                );
                                                              }
                                                            } else {
                                                              showDialog(
                                                                context:
                                                                    navigatorKey
                                                                        .currentContext!,
                                                                barrierDismissible:
                                                                    false,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16),
                                                                    ),
                                                                    title: Row(
                                                                      children: [
                                                                        Icon(
                                                                            Icons
                                                                                .verified_user,
                                                                            color:
                                                                                Colors.redAccent),
                                                                        SizedBox(
                                                                            width:
                                                                                8),
                                                                        Text(
                                                                          "CNIC Verification Required",
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    content:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Please verify your CNIC before proceeding.",
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                12),
                                                                        Text(
                                                                          "• If you are a Taker: You cannot request blood without CNIC verification.\n\n"
                                                                          "• If you are a Donor: You cannot donate blood without verifying your CNIC.\n\n"
                                                                          "👉 Go to your account section and verify your CNIC to continue.",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.black87),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.of(context).pop(),
                                                                        child: Text(
                                                                            "Later",
                                                                            style:
                                                                                TextStyle(color: Colors.black)),
                                                                      ),
                                                                      ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          backgroundColor:
                                                                              Colors.redAccent,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          // Navigate to Account section
                                                                          Navigator.pushNamed(
                                                                              context,
                                                                              "/account");
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Verify Now",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            }
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 140,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                              color:
                                                                  Colors.green,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          child: Text(
                                                            'Accept',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        );
                                      });
                                }
                              },
                            ))
                  ],
                ),
              ));
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
