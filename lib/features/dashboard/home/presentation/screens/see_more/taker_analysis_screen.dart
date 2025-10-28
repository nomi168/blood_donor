import 'dart:async';

import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/features/dashboard/home/data/models/donor_accept_model.dart';
import 'package:blood_donor/features/dashboard/home/presentation/controllers/taker_anaylsis_controller.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/dashboatd.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/see_more/feedback_screen.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/see_more/taker_reach.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class TakerAnalysisScreen extends StatelessWidget {
  final DonateAcceptModel donateModel;
  final Completer<GoogleMapController> mapController;
  const TakerAnalysisScreen(
      {super.key, required this.donateModel, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TakerAnaylsisController>(
      init: TakerAnaylsisController(
          payload: donateModel, mapController: mapController),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            actions: [
              // IconButton to show path
              IconButton(
                onPressed: () {
                  controller.showPath(donateModel.location);
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 41.h,
                  child: GoogleMap(
                    onMapCreated: (mapController) {
                      if (!controller.controllers.isCompleted) {
                        controller.controllers.complete(mapController);
                      }
                    },
                    myLocationEnabled: true,
                    polylines: controller.polylines,
                    circles: controller.circles,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(31.5820, 74.3294), // Lahore as fallback
                      zoom: 14,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(
                          Icons.bloodtype,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Cancel Request",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: Row(
                                  children: const [
                                    Icon(Icons.warning_amber_rounded,
                                        color: Colors.red, size: 28),
                                    SizedBox(width: 8),
                                    Text(
                                      "Cancel Blood Request",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                content: const Text(
                                  "Are you sure you want to cancel this blood request?\n\nThis action cannot be undone.",
                                  style: TextStyle(fontSize: 15),
                                ),
                                actionsPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                actions: [
                                  TextButton(
                                    child: const Text(
                                      "No, Keep it",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.delete_forever,
                                        color: Colors.white, size: 18),
                                    label: const Text(
                                      "Yes, Cancel",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(
                                          context); // Close dialog first

                                      Map<String, dynamic> payload = {
                                        'donor_email': donateModel.donorEmail,
                                        'email': donateModel.email,
                                        'is_delete': true,
                                        'received_status': true,
                                        'taker_received_status': true,
                                      };
                                      bool result = await controller
                                          .deleteAcceptedRequest(payload);
                                      if (result) {
                                        Get.offAll(() => Dashboard());
                                        Get.snackbar(
                                          "Request Canceled",
                                          "Your blood request has been successfully canceled.",
                                          backgroundColor: Colors.green
                                              .withValues(alpha: .9),
                                          colorText: Colors.white,
                                          icon: const Icon(Icons.check_circle,
                                              color: Colors.white),
                                          duration: const Duration(seconds: 3),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(
                          Icons.directions,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Travel Tracking",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          await controller
                                              .sendNotificationToDonorReached(
                                            donateModel.donorEmail,
                                          );
                          // await controller.getCurrentLocation();
                          Get.to(() => TakerReachScreen(
                                acceptModel: donateModel,
                                mapController: controller.mapController,
                                donorLocation: controller.donorLocation,
                              ));
                        },
                      ),
                    ],
                  ),
                ),
                controller.isReceived == true
                    ? GetBuilder<TakerAnaylsisController>(
                        builder: (controller) {
                          if (controller.colorAnimation.isAnimating == false) {
                            return const SizedBox
                                .shrink(); // wait until initialized
                          }

                          return AnimatedBuilder(
                            animation: controller.tapCountReceived > 1
                                ? controller.colorAnimation
                                : controller.colorAnimation,
                            builder: (context, child) {
                              return InkWell(
                                splashColor: Colors.transparent,
                                splashFactory: NoSplash.splashFactory,
                                onTap: controller.tapCountReceived >= 1
                                    ? null
                                    : () async {
                                        if (controller.isReceived == true) {
                                          bool response = await controller
                                              .sendNotificationToDonorReached(
                                            donateModel.donorEmail,
                                          );
                                          if (response) {
                                            controller.tapCountReceived++;
                                            Get.snackbar(
                                              "Success",
                                              "notification successfully sending",
                                              snackPosition: SnackPosition.TOP,
                                              snackStyle: SnackStyle.FLOATING,
                                              backgroundColor: Colors.green
                                                  .withValues(alpha: 0.9),
                                              colorText: Colors.white,
                                              margin: EdgeInsets.all(10),
                                              duration: Duration(seconds: 3),
                                              borderRadius: 8,
                                              icon: Icon(Icons.check_circle,
                                                  color: Colors.white),
                                            );
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            bool isReceive = await prefs.getBool(
                                                    'ID_${donateModel.id}') ??
                                                false;
                                            if (isReceive) {
                                              controller.tapCountReceived = 2;
                                              controller.update();
                                            } else {
                                              await prefs.setBool(
                                                  'ID_${donateModel.id}', true);
                                            }
                                          }

                                          if (controller.tapCountReceived >=
                                              1) {
                                            controller.animationController
                                                .stop();
                                            controller
                                                .update(); // stop blinking
                                          }
                                        } else {
                                          Get.snackbar(
                                            "Error",
                                            "You already notified ${donateModel.donorName}",
                                            snackPosition: SnackPosition.TOP,
                                            snackStyle: SnackStyle.FLOATING,
                                            backgroundColor: Colors.red
                                                .withValues(alpha: 0.9),
                                            colorText: Colors.white,
                                            margin: const EdgeInsets.all(10),
                                            duration:
                                                const Duration(seconds: 3),
                                            borderRadius: 8,
                                            icon: const Icon(Icons.error,
                                                color: Colors.white),
                                          );
                                        }
                                      },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: controller.tapCountReceived > 1
                                        ? Colors.green
                                        : controller.colorAnimation.value,
                                    borderRadius: BorderRadius.circular(6),
                                    border:
                                        Border.all(color: Colors.transparent),
                                  ),
                                  child: Text(
                                    'Confirm Donation',
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : SizedBox(),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    "ETA: ${controller.hours}h ${controller.minutes}m ${controller.seconds}s | "
                    "Distance: ${controller.distanceInKm.toStringAsFixed(2)} km",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Donor Info',
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
                            Expanded(
                              child: Text(donateModel.donorBlood,
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
                                'Donor Name ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                donateModel.donorName,
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
                          children: [
                            Expanded(
                              child: Text(
                                'Hospital Name ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                donateModel.hospitalName,
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
                          children: [
                            Expanded(
                              child: Text(
                                'Date & Time ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${donateModel.date} ${donateModel.time}',
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
                      ]),
                ),
                SizedBox(
                  height: 10,
                ),
                controller.isNextProcess
                    ? InkWell(
                        splashColor: Colors.transparent,
                        splashFactory: NoSplash.splashFactory,
                        onTap: () async {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return FeedbackDonorScreen(
                                  donateModel: donateModel,
                                  mapController: controller.mapController,
                                );
                              },
                              transitionDuration:
                                  const Duration(microseconds: 100),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(
                                    10.0, 0.0); // slide in from the right
                                const end = Offset.zero;
                                const curve = Curves.easeInOutQuart;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: PRIMARY_COLOR,
                              borderRadius: BorderRadius.circular(06),
                              border: Border.all(color: Colors.black26)),
                          child: Text(
                            'Continue',
                            style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
