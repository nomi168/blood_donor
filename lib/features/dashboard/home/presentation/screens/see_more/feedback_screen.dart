// ignore_for_file: file_names

import 'dart:async';

import 'package:blood_donor/features/dashboard/home/data/models/donor_accept_model.dart';
import 'package:blood_donor/features/dashboard/home/presentation/controllers/donor_feedback_controller.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/see_more/complete_taker_journey_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

class FeedbackDonorScreen extends StatelessWidget {
  final DonateAcceptModel donateModel;
  final Completer<GoogleMapController> mapController;
  const FeedbackDonorScreen(
      {super.key, required this.donateModel, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DonorFeedbackController>(
      init: DonorFeedbackController(
          payload: donateModel, mapController: mapController),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              // IconButton to show path
              IconButton(
                onPressed: () {
                  controller.showPathOnMap(donateModel.location);
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
              Switch(
                value: controller.isLightMode,
                onChanged: (value) {
                  controller.isLightMode = value;
                  controller.update();

                  controller.toggleMapMode();
                },
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(children: [
              Container(
                color: const Color.fromRGBO(244, 67, 54, 1),
                height: 27.h,
                width: double.infinity,
                child: GoogleMap(
                    mapType: controller.isLightMode
                        ? MapType.normal
                        : MapType.hybrid,
                    initialCameraPosition: controller.kGooglePlex,
                    polylines: Set<Polyline>.of(controller.polylines),
                    circles: Set<Circle>.of(controller.circles),
                    onMapCreated: (GoogleMapController controllern) {
                      if (!controller.controllers.isCompleted) {
                        controller.controllers.complete(controllern);
                      }
                    }),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Distance-',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Text(
                          '${controller.distanceInKm.toStringAsFixed(2)} km',
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
                          'Time of Distance-',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Text(
                          "${controller.hours} hour ${controller.minutes} mintutes ${controller.seconds} sec ",
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
                          'Review-',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        buildStar(1, controller),
                        buildStar(2, controller),
                        buildStar(3, controller),
                        buildStar(4, controller),
                        buildStar(5, controller),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
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
                height: 10.h,
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: controller.review,
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
                padding: EdgeInsets.fromLTRB(5.w, 0.h, 5.w, 0),
                child: ElevatedButton(
                  onPressed: () async {
                    double finalRating = 0.0;
                    if (controller.selectedRating == -1) {
                      finalRating = 0.0;
                      finalRating =
                          double.parse(controller.takerRating.toString());
                    } else {
                      finalRating = (controller.selectedRating +
                              controller.takerRating!) /
                          2;
                    }

                    Map<String, dynamic> payload = {
                      'donor_email': donateModel.donorEmail,
                      'rating': finalRating.toString(),
                      'review': controller.review.text.trim(),
                    };
                    bool result =
                        await controller.updateAcceptDonationData(payload);
                    if (result) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return CompleteTakerJourneyScreen();
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
                    }
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
                      EdgeInsets.symmetric(vertical: 2.2.h, horizontal: 25.w),
                    ),
                    backgroundColor:
                        WidgetStateProperty.all<Color>(const Color(0xFFDE0A1E)),
                  ),
                  child: Text(
                    'Submit Your Review',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }

  Widget buildStar(int starNumber, DonorFeedbackController controller) {
    return GestureDetector(
      onTap: () {
        controller.selectedRating = starNumber;
        controller.update();
      },
      child: Icon(
        Icons.star,
        size: 23,
        color: starNumber <= controller.selectedRating
            ? const Color.fromARGB(255, 224, 208, 63)
            : Colors.black54,
      ),
    );
  }
}
