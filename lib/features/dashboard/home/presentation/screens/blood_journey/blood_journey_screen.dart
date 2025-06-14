// ignore_for_file: file_names

import 'dart:async';

import 'package:blood_donor/constants.dart';
import 'package:blood_donor/features/dashboard/home/data/models/donor_accept_model.dart';
import 'package:blood_donor/features/dashboard/home/presentation/controllers/blood_journey_controller.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/Dashboatd.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/blood_journey/compete_journey_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

class BloodJourneyScreen extends StatelessWidget {
  final DonateAcceptModel donateModel;
  final Completer<GoogleMapController> mapController;
  const BloodJourneyScreen(
      {super.key, required this.donateModel, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BloodJourneyController>(
        init: BloodJourneyController(
            payload: donateModel, mapController: mapController),
        builder: (bloodController) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                // IconButton to show path
                IconButton(
                  onPressed: () {
                    bloodController.showPathOnMap(donateModel.location);
                  },
                  icon: const Icon(Icons.directions),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0.w, 0, 0, 0),
                    child: IconButton(
                      onPressed: bloodController.goToCurrentLocation,
                      icon: const Icon(
                        Icons.my_location,
                        size: 35,
                        color: Colors.black54,
                      ),
                    )),
                // Switch for light/dark mode
                Switch(
                  value: bloodController.isLightMode,
                  onChanged: (value) {
                    bloodController.isLightMode = value;
                    bloodController.update();

                    bloodController.toggleMapMode();
                  },
                ),
              ],
            ),
            backgroundColor: Colors.white,
            body: Column(children: [
              Container(
                color: const Color.fromRGBO(244, 67, 54, 1),
                height: 30.h,
                width: double.infinity,
                child: GoogleMap(
                  mapType: bloodController.isLightMode
                      ? MapType.normal
                      : MapType.hybrid,
                  initialCameraPosition: bloodController.kGooglePlex,
                  polylines: Set<Polyline>.of(bloodController.polylines),
                  circles: Set<Circle>.of(bloodController.circles),
                  onMapCreated: (GoogleMapController controllern) {
                    if (!bloodController.controllers.isCompleted) {
                      bloodController.controllers.complete(controllern);
                    }
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 5),
                  height: 4,
                  width: 20.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(10),
                  )),
              SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF3F3F3).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      width: 1, color: Colors.grey.withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                height: 10.h,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 70,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: donateModel.image.isNotEmpty
                              ? donateModel.image
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
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          donateModel.fullname,
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Text(
                          donateModel.hospitalName,
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Donation Details',
                style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF3F3F3).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      width: 1, color: Colors.grey.withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Location-',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Text(
                          donateModel.location,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Schedule-',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Text(
                          donateModel.time,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          donateModel.date,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF3F3F3).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      width: 1, color: Colors.grey.withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                width: double.infinity,
                height: 17.h,
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextField(
                  controller: bloodController.review,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 00.0),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    hintText: 'Enter your suggestion here!',
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          dynamic payload = {
                            'donor_email': donateModel.donorEmail,
                            'email': donateModel.email
                          };
                          bool result = await bloodController
                              .deleteAcceptedRequest(payload);
                          if (result) {
                            Get.offAll(() => Dashboard());
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 11),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(08),
                              border: Border.all(color: PRIMARY_COLOR)),
                          alignment: Alignment.center,
                          child: Text(
                            'Cancel Request',
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          Map<String,dynamic> payload = {
                            'donor_email': donateModel.donorEmail,
                            'email': donateModel.email
                          };
                          bool? result =
                              await bloodController.getReceivedStatus(payload);
                          if (result) {
                            _showConfirmationDialog(
                                context, payload, bloodController, donateModel);
                          } else {
                            showCustomSnackBar(
                                context,
                                'The taker has not received it at your location yet',
                                false);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 11),
                          decoration: BoxDecoration(
                              color: PRIMARY_COLOR,
                              borderRadius: BorderRadius.circular(08),
                              border: Border.all(color: PRIMARY_COLOR)),
                          alignment: Alignment.center,
                          child: Text(
                            'Continue',
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // Padding(
              //     padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0.h),
              //     child: SizedBox(
              //       height: 6.h,
              //       width: 100.w,
              //       child: Material(
              //           borderRadius: BorderRadius.circular(10.0),
              //           elevation: 5.0,
              //           color: const Color(0xFFDE0A1E),
              //           child: Row(
              //             children: [
              //               Padding(
              //                   padding: EdgeInsets.fromLTRB(5.w, 0, 0, 0),
              //                   child: TextButton(
              //                     child: Text(
              //                       'Cancel Request',
              //                       style: TextStyle(
              //                           fontSize: 12.sp,
              //                           fontWeight: FontWeight.bold,
              //                           color: Colors.white70),
              //                     ),
              //                     onPressed: () async {
              //                       await deleteAcceptRequest();
              //                     },
              //                   )),
              //               Padding(
              //                 padding: EdgeInsets.fromLTRB(4.w, 0, 0, 0),
              //                 child: const VerticalDivider(
              //                   color: Colors.white, // Adjust the color as needed
              //                   thickness: 2.0, // Adjust the thickness as needed
              //                 ),
              //               ),
              //               Padding(
              //                   padding: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
              //                   child: TextButton(
              //                     child: Text(
              //                       'Donated',
              //                       style: TextStyle(
              //                           fontSize: 12.sp,
              //                           fontWeight: FontWeight.bold,
              //                           color: Colors.white),
              //                     ),
              //                     onPressed: () {
              //                       _showConfirmationDialog(context);
              //                     },
              //                   ))
              //             ],
              //           )),
              //     ))
            ]),
          );
        });
  }

  Future<void> _showConfirmationDialog(BuildContext context, dynamic payload,
      BloodJourneyController controller, DonateAcceptModel model) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          actions: <Widget>[
            Column(
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Image.asset('images/fi_16322725.png'),
                Container(
                  margin: EdgeInsets.only(top: 1.h),
                  child: Text(
                    'Congratulations',
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 3.h),
                  child: Text(
                    'You have Successfully donated blood to the seeker',
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.w, 3.h, 3.w, 0),
                  child: ElevatedButton(
                    onPressed: () async {
                      controller.updateTakerReceivedStatue(
                          payload['email'], payload['donor_email']);

                      // String name = widget.name;
                      // String image = widget.image;
                      // String blood = widget.blood;
                      // String hospital = widget.hospital;
                      // String location = widget.location;
                      // String date = widget.date;
                      // String time = widget.time;
                      // String rating = widget.rating;
                      // String note = widget.note;
                      // String review1 = review.text;
                      // String id = widget.id; String name = widget.name;
                      // String image = widget.image;
                      // String blood = widget.blood;
                      // String hospital = widget.hospital;
                      // String location = widget.location;
                      // String date = widget.date;
                      // String time = widget.time;
                      // String rating = widget.rating;
                      // String note = widget.note;
                      // String review1 = review.text;
                      // String id = widget.id;
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return CompeteJourneyScreen(
                              donateModel: model,
                            );
                          },
                          transitionDuration: const Duration(microseconds: 100),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin =
                                Offset(10.0, 0.0); // slide in from the right
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
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                        // Increase horizontal padding
                        // ignore: prefer_const_constructors
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 25.w),
                      ),
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFFDE0A1E)),
                    ),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
