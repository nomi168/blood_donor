import 'dart:async';

import 'package:blood_donor/features/auth/data/models/user_model.dart';
import 'package:blood_donor/features/dashboard/post_blood/data/models/user_location_model.dart';
import 'package:blood_donor/features/dashboard/post_blood/presentation/controllers/map_request_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapRequestScreen extends StatelessWidget {
  final Map<String, dynamic> payload;
  final Completer<GoogleMapController> controller;
  final List<UserModel> userList;
  final List<UserLocationModel> userLocationList;
  const MapRequestScreen(
      {super.key,
      required this.payload,
      required this.controller,
      required this.userList,
      required this.userLocationList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: GetBuilder<MapRequestController>(
        init: MapRequestController(
            payload: payload, controller: controller, userList: userList,locationList: userLocationList),
        builder: (mapController) {
          return Stack(children: [
            GoogleMap(
              myLocationButtonEnabled: true,
              minMaxZoomPreference: MinMaxZoomPreference.unbounded,
              mapToolbarEnabled: true,
              mapType: MapType.hybrid,
              onMapCreated: (GoogleMapController controllern) {
                if (!mapController.controller1.isCompleted) {
                  mapController.controller1.complete(controllern);
                }
              },
              markers: mapController.markers,
              initialCameraPosition: CameraPosition(
                  target: LatLng(0, 0), // Default position, adjust as needed
                  zoom: 10 // Default zoom level, adjust as needed
                  ),
            ),
            Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () async {
                    mapController.sendNotificationsToNearbyDonors(
                        mapController.nearbyDonors);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10, top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    height: 40,
                    width: 90,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Post Blood',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Icon(Icons.circle_notifications_outlined)
                      ],
                    ),
                  ),
                ))
          ]);
        },
      ),
    ));
  }
}
