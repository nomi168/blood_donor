import 'dart:async';

import 'package:blood_donor/constants.dart';
import 'package:blood_donor/features/dashboard/home/data/models/donor_accept_model.dart';
import 'package:blood_donor/features/dashboard/home/presentation/controllers/taker_reach_controller.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/see_more/feedback_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

class TakerReachScreen extends StatelessWidget {
  final DonateAcceptModel acceptModel;
  final Completer<GoogleMapController> mapController;
  const TakerReachScreen(
      {super.key, required this.acceptModel, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TakerReachController>(
      init: TakerReachController(
          payload: acceptModel, mapController: mapController),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              // IconButton to show path
              IconButton(
                onPressed: () {
                  controller.showPath(acceptModel.location);
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
                height: 41.h,
                child: GoogleMap(
                  mapType:
                      controller.isLightMode ? MapType.normal : MapType.hybrid,
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
                'Confirm your Availabilty',
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
                          Text(
                            'Blood Group ',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black54),
                          ),
                          Spacer(),
                          Text(acceptModel.blood,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54)),
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
                          Text(
                            'Address ',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black54),
                          ),
                          Spacer(),
                          Text(
                            acceptModel.location,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black54),
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
                          Text(
                            'Hospital Name ',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black54),
                          ),
                          Spacer(),
                          Text(
                            acceptModel.hospitalName,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black54),
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
                          Text(
                            'Rating ',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black54),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 5,
                          )
                        ],
                      ),
                    ]),
              ),
              !controller.isReceived
                  ? InkWell(
                      splashColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      onTap: () async {
                        if (controller.isReceived == false) {
                          bool? response =
                              await controller.sendNotificationToDonor(
                                  acceptModel.donorEmail,
                                  controller.hours,
                                  controller.minutes,
                                  controller.seconds);
                          if (response) {
                            controller.isReceived = true;
                            controller.update();
                          }
                        } else {
                          showCustomSnackBar(
                              context,
                              'you are already notify to ${acceptModel.donorName}',
                              false);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(06),
                            border: Border.all(color: Colors.black26)),
                        child: Text(
                          'On going',
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 10,
              ),
              controller.isReceived
                  ? InkWell(
                      splashColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      onTap: () async {
                        await controller.sendNotificationToDonorReached(
                            acceptModel.donorEmail);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(06),
                            border: Border.all(color: Colors.black26)),
                        child: Text(
                          'Received',
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 10,
              ),
              controller.isReceived
                  ? InkWell(
                      splashColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      onTap: () async {
                        bool result = await controller.getTakerReceivedStatus(
                            acceptModel.email, acceptModel.donorEmail);
                        if (result) {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return FeedbackDonorScreen(
                                  donateModel: acceptModel,
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
                        }
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
            ],
          ),
        );
      },
    );
  }
}
