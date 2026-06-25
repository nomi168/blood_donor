// ignore_for_file: file_names

import 'dart:async';
import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/home/data/models/donor_accept_model.dart';
import 'package:blood_donor/features/dashboard/home/data/models/taker_model.dart';
import 'package:blood_donor/features/dashboard/home/presentation/controllers/donate_controller.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/dashboard.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class DonateBoodScreen extends StatelessWidget {
  final FeedTakerModel payload;
  final Completer<GoogleMapController> mapController;
  const DonateBoodScreen(
      {super.key, required this.payload, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DonateBloodController>(
      init:
          DonateBloodController(payload: payload, mapController: mapController),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            actions: [
              // IconButton to show path
              IconButton(
                onPressed: () {
                  controller.showPathOnMap(payload.location!);
                },
                icon: const Icon(Icons.directions),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0.w, 0, 0, 0),
                  child: IconButton(
                    onPressed: controller.goToCurrentLocation,
                    icon: const Icon(
                      Icons.my_location,
                      size: 35,
                      color: Colors.black54,
                    ),
                  )),
              // Switch for light/dark mode
              // Switch(
              //   value: controller.isLightMode,
              //   onChanged: (value) {
              //     controller.isLightMode = value;
              //     controller.update();

              //     controller.toggleMapMode();
              //   },
              // ),
            ],
          ),
          body: Column(
            children: [
              Container(
                  height: 300,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: controller.kGooglePlex,
                    polylines: Set<Polyline>.of(controller.polylines),
                    circles: Set<Circle>.of(controller.circles),
                    onMapCreated: (GoogleMapController controllern) {
                      if (!controller.controllers.isCompleted) {
                        controller.controllers.complete(controllern);
                      }
                    },
                  )),
              SizedBox(
                height: 5,
              ),
              Text(
                'Confirm your Donor',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white, // Optional: Background color
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 0.5, color: Color(0xFFDDDDDD)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Blood Group ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54),
                            ),
                          ),
                          // Spacer(),
                          Expanded(
                            child: Text(payload.blood!,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54)),
                          ),
                          SizedBox(
                            width: 5,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Address ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54),
                            ),
                          ),
                          // Spacer(),
                          Expanded(
                            child: Text(
                              payload.location!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Hospital Name ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54),
                            ),
                          ),
                          // Spacer(),
                          Expanded(
                            child: Text(
                              payload.hospitalName!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ]),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white, // Optional: Background color
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 0.5, color: Color(0xFFDDDDDD)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: payload.image!.isNotEmpty
                                      ? payload.image!
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
                            const SizedBox(width: 10),
                            Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    payload.name!,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500),
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
                                        DateFormat('dd-MM-yyyy').format(
                                            DateTime.parse(payload.date!)),
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
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
                                        payload.time!,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black45),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.social_distance,
                                        color: Colors.black54,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${controller.distance.toStringAsFixed(2)} km Away',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                      )
                                    ],
                                  )
                                ],
                              ),
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
                                          context, payload.note!),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 30),
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(color: PRIMARY_COLOR)),
                                child: Icon(
                                  Icons.info,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ]),
                    ]),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (controller.distance > 20.0) {
                      Get.snackbar(
                        "Info",
                        "You cannot donate blood because you are not within a 20 km range.",
                        snackPosition: SnackPosition.TOP,
                        snackStyle: SnackStyle.FLOATING,
                        backgroundColor: Colors.blue.withValues(alpha: 0.9),
                        colorText: Colors.white,
                        margin: EdgeInsets.all(10),
                        duration: Duration(seconds: 3),
                        borderRadius: 8,
                        icon: Icon(Icons.info, color: Colors.white),
                      );
                      Get.offAll(() => Dashboard());
                    } else {
                      final user = UserController.to.userModel!;
                      DateTime dates = DateTime.now();

                      String dateOnly =
                          "${dates.year}-${dates.month.toString().padLeft(2, '0')}-${dates.day.toString().padLeft(2, '0')}";
                      int hour = dates.hour;
                      String period = hour >= 12 ? "PM" : "AM";
                      hour = hour % 12 == 0 ? 12 : hour % 12;

                      String timeOnly =
                          "${hour.toString().padLeft(2, '0')}:${dates.minute.toString().padLeft(2, '0')} $period";
                      Map<String, dynamic> payload1 = {
                        'id': '',
                        'takerid': payload.takerId,
                        'fullname': payload.name,
                        'image': payload.image,
                        'email': payload.email,
                        'hospitalname': payload.hospitalName,
                        'date': payload.date,
                        'time': payload.time,
                        'location': payload.location,
                        'note': payload.note,
                        'blood': payload.blood,
                        'unit': payload.unit,
                        'phone_number': payload.number,
                        'situation': payload.situation,
                        'bloodtype': payload.bloodType,
                        'donor_name': '${user.firstname} ${user.lastname}',
                        'donor_email': user.email,
                        'donor_number': user.phonenumber,
                        'donor_image': user.image,
                        'donor_blood': user.bloodgroup,
                        'accept_date': dateOnly,
                        'accept_time': timeOnly,
                        'status': false,
                        'received_status': false,
                        'taker_received_status': false,
                        'is_delete': false
                      };

                      bool result =
                          await controller.aceeptDonationRequest(payload1);

                      if (result) {
                        Get.snackbar(
                          "Success",
                          "accepting request successfully",
                          snackPosition: SnackPosition.TOP,
                          snackStyle: SnackStyle.FLOATING,
                          backgroundColor: Colors.green.withValues(alpha: 0.9),
                          colorText: Colors.white,
                          margin: EdgeInsets.all(10),
                          duration: Duration(seconds: 3),
                          borderRadius: 8,
                          icon: Icon(Icons.check_circle, color: Colors.white),
                        );

                        DonateAcceptModel? model =
                            await controller.getSingleDonorAcceptance(
                                payload.email!,
                                UserController.to.userModel!.email);
                        if (model != null) {
                          controller.sendNotification(payload.email!);
                          showDonatePopup(
                              context, controller.mapController, model);
                        }
                      } else {
                        Get.snackbar(
                          "Error",
                          "This taker is in donation mood",
                          snackPosition: SnackPosition.TOP,
                          snackStyle: SnackStyle.FLOATING,
                          backgroundColor: Colors.red.withValues(alpha: 0.9),
                          colorText: Colors.white,
                          margin: EdgeInsets.all(10),
                          duration: Duration(seconds: 3),
                          borderRadius: 8,
                          icon: Icon(Icons.error, color: Colors.white),
                        );

                        Get.offAll(() => Dashboard());
                      }
                    }
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    backgroundColor:
                        WidgetStateProperty.all<Color>(const Color(0xFFDE0A1E)),
                  ),
                  child: Text(
                    'Accept Request',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void showDonatePopup(
      BuildContext context,
      final Completer<GoogleMapController> mapController,
      DonateAcceptModel model) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          backgroundColor: Colors.white,
          title: Center(
            child: Column(
              children: [
                // Your image goes here
                Image.asset(
                  'images/pop.jpeg',
                  height: 20.h,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Donate',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Your donation popup content goes here
              Text(
                'Thanks for accepting the request.\nNow check Donation details in blood journey map',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.fromLTRB(15.w, 5.h, 15.w, 0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAll(() => Dashboard());
                    // Navigator.push(
                    //   context,
                    //   PageRouteBuilder(
                    //     pageBuilder: (context, animation, secondaryAnimation) {
                    //       return DonorLocationScreen(
                    //         donateModel: model,
                    //         mapController: mapController,
                    //       );
                    //     },
                    //     transitionDuration: const Duration(microseconds: 100),
                    //     transitionsBuilder:
                    //         (context, animation, secondaryAnimation, child) {
                    //       const begin =
                    //           Offset(10.0, 0.0); // slide in from the right
                    //       const end = Offset.zero;
                    //       const curve = Curves.easeInOutQuart;

                    //       var tween = Tween(begin: begin, end: end)
                    //           .chain(CurveTween(curve: curve));
                    //       var offsetAnimation = animation.drive(tween);

                    //       return SlideTransition(
                    //         position: offsetAnimation,
                    //         child: child,
                    //       );
                    //     },
                    //   ),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      elevation: 8,
                      padding: EdgeInsets.all(4.0.w),
                      backgroundColor: const Color(0xFFDE0A1E)),
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
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
