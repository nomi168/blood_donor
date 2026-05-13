import 'dart:async';

import 'package:blood_donor/features/auth/data/models/user_model.dart';
import 'package:blood_donor/features/dashboard/post_blood/data/models/user_location_model.dart';
import 'package:blood_donor/features/dashboard/post_blood/presentation/controllers/map_request_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapRequestScreen extends StatelessWidget {
  final Map<String, dynamic> payload;
  final Completer<GoogleMapController> controller;
  final List<UserModel> userList;
  final List<UserLocationModel> userLocationList;
  final List<Map<String,dynamic>> imageList;
  const MapRequestScreen(
      {super.key,
      required this.payload,
      required this.controller,
      required this.userList,
      required this.userLocationList,
      required this.imageList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: GetBuilder<MapRequestController>(
        init: MapRequestController(
            payload: payload,
            controller: controller,
            userList: userList,
            locationList: userLocationList,
            imageList: imageList),
        builder: (mapController) {
          return Stack(children: [
            GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: false, // use your own floating button
              zoomControlsEnabled: false, // cleaner UI
              mapToolbarEnabled: false,
              compassEnabled: true,
              trafficEnabled: true,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              mapType: MapType.terrain, // cleaner than terrain for UI
              markers: mapController.markers,
              initialCameraPosition: const CameraPosition(
                target: LatLng(33.6844, 73.0479), // Example: Islamabad
                zoom: 13.5,
                tilt: 40,
                bearing: 30,
              ),
              onMapCreated: (GoogleMapController controllern) async {
                if (!mapController.controller1.isCompleted) {
                  mapController.controller1.complete(controllern);
                }
                String style =
                    await rootBundle.loadString('images/json/google_map.json');
                controllern.setMapStyle(style);
              },
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
