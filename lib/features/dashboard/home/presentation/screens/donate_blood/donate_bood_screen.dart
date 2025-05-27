// ignore_for_file: file_names

import 'dart:async';

import 'package:blood_donor/constants.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/home/data/models/donor_accept_model.dart';
import 'package:blood_donor/features/dashboard/home/data/models/taker_model.dart';
import 'package:blood_donor/features/dashboard/home/presentation/controllers/donate_controller.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/Dashboatd.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/blood_journey/blood_journey_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
          body: Column(
            children: [
              Container(
                  height: 300,
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
                    },
                  )),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  height: 5,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(08),
                      color: Colors.black38),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(06),
                    color: Colors.grey.shade300),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(payload.image!),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(payload.name!,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text('blood-type: ${payload.bloodType}',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                            Text('blood: ${payload.blood}',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(06),
                    color: Colors.grey.shade300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('hospital-name: ${payload.hospitalName}',
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    Text('location: ${payload.location}',
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    Text('time: ${payload.date} ${payload.time}',
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(06),
                    color: Colors.grey.shade300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('number: ${payload.number}',
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    Text('note: ${payload.note}',
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final user = UserController.to.userModel!;
                    DateTime dates = DateTime.now();

                    String dateOnly =
                        "${dates.year}-${dates.month.toString().padLeft(2, '0')}-${dates.day.toString().padLeft(2, '0')}";
                    int hour = dates.hour;
                    String period = hour >= 12 ? "PM" : "AM";
                    hour = hour % 12 == 0 ? 12 : hour % 12;

                    String timeOnly =
                        "${hour.toString().padLeft(2, '0')}:${dates.minute.toString().padLeft(2, '0')} $period";
                    dynamic payload1 = {
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
                      'taker_received_status': false
                    };

                    bool result =
                        await controller.aceeptDonationRequest(payload1);

                    if (result) {
                      showCustomSnackBar(
                          context, 'accepting request successfully', true);
                      DonateAcceptModel? model =
                          await controller.getSingleDonorAcceptance(
                              payload.email!,
                              UserController.to.userModel!.email);
                      if (model != null) {
                        showDonatePopup(
                            context, controller.mapController, model);
                      }
                    } else {
                      showCustomSnackBar(
                          context, 'This taker is in donation mood', false);
                      Get.offAll(() => Dashboard());
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
                    'Donate Now',
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
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return BloodJourneyScreen(
                            donateModel: model,
                            mapController: mapController,
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
