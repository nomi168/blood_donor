// ignore_for_file: avoid_print, file_names, await_only_futures

import 'dart:async';

import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/features/dashboard/feeds/presentation/controller/map_donate_controller.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/dashboatd.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class MapOnDonator extends StatefulWidget {
  Map<String, dynamic> payload;
  final Completer<GoogleMapController> mapController;
  // ignore: non_constant_identifier_names
  MapOnDonator({Key? key, required this.payload, required this.mapController})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MapOnDonatorState createState() => _MapOnDonatorState();
}

class _MapOnDonatorState extends State<MapOnDonator> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapDonateController>(
      init: MapDonateController(
          payload: widget.payload, mapController: widget.mapController),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            actions: [
              // IconButton to show path
              IconButton(
                onPressed: () {
                  controller.showPathOnMap(widget.payload['location']);
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
              //   activeColor: PRIMARY_COLOR,
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
                    mapType: MapType.normal,
                    initialCameraPosition: controller.kGooglePlex,
                    polylines: Set<Polyline>.of(controller.polylines),
                    circles: Set<Circle>.of(controller.circles),
                    onMapCreated: (GoogleMapController controllern) {
                      if (!controller.controllers.isCompleted) {
                        controller.controllers.complete(controllern);
                      }
                    },
                  ),
                ),
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
                              child: Text(widget.payload['blood'],
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
                                widget.payload['location'],
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
                            // Spacer(),
                            Expanded(
                              child: Text(
                                widget.payload['hospitalname'],
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
                                    imageUrl: widget.payload['image'].isNotEmpty
                                        ? widget.payload['image']
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
                                      widget.payload['fullname'],
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
                                          widget.payload['date'],
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
                                          widget.payload['time'],
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
                                          '${controller.shortdistance.toStringAsFixed(2)} km Away',
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
                                            context, widget.payload['note']),
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
                  width: double.infinity,
                  height: 9.h,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  // margin: EdgeInsets.only(top: 20.h),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (controller.shortdistance > 20.0) {
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
                        DateTime dates = DateTime.now();

                        String dateOnly =
                            "${dates.year}-${dates.month.toString().padLeft(2, '0')}-${dates.day.toString().padLeft(2, '0')}";
                        int hour = dates.hour;
                        String period = hour >= 12 ? "PM" : "AM";
                        hour = hour % 12 == 0 ? 12 : hour % 12;

                        String timeOnly =
                            "${hour.toString().padLeft(2, '0')}:${dates.minute.toString().padLeft(2, '0')} $period";

                        widget.payload['accept_date'] = dateOnly;
                        widget.payload['accept_time'] = timeOnly;

                        widget.payload;
                        bool result = await controller
                            .aceeptDonationRequest(widget.payload);
                        if (result) {
                          Get.snackbar(
                            "Success",
                            "accepting request successfully",
                            snackPosition: SnackPosition.TOP,
                            snackStyle: SnackStyle.FLOATING,
                            backgroundColor:
                                Colors.green.withValues(alpha: 0.9),
                            colorText: Colors.white,
                            margin: EdgeInsets.all(10),
                            duration: Duration(seconds: 3),
                            borderRadius: 8,
                            icon: Icon(Icons.check_circle, color: Colors.white),
                          );
                          controller.sendNotification(widget.payload['email']);

                          _showDonatePopup();
                        } else {
                          Get.snackbar(
                            "Error",
                            "This taker is in donation mood.",
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
                      // _acceptRequest();
                    },
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      // padding:
                      //     MaterialStateProperty.all<EdgeInsetsGeometry>(
                      //   // Increase horizontal padding
                      //   // ignore: prefer_const_constructors
                      //   EdgeInsets.symmetric(
                      //       vertical: 2.h, horizontal: 32.w),
                      // ),
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFFDE0A1E)),
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
          ),
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

  // ignore: unused_element
  void _showDonatePopup() {
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
                  'images/image2.jpeg',
                  height: 40.h,
                  width: 40.w,
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
}
