import 'dart:async';

import 'package:blood_donor/features/dashboard/home/data/models/donor_accept_model.dart';
import 'package:blood_donor/features/dashboard/home/presentation/controllers/taker_reach_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

class TakerReachScreen extends StatelessWidget {
  final DonateAcceptModel acceptModel;
  final Completer<GoogleMapController> mapController;
  final String donorLocation;
  const TakerReachScreen(
      {super.key, required this.acceptModel, required this.mapController,required this.donorLocation});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TakerReachController>(
      init: TakerReachController(
          payload: acceptModel, mapController: mapController,donorLocation: donorLocation),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
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
            ],
          ),
          body: Stack(
            children: [
              Positioned.fill(
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
              Positioned(
                bottom: 10,
                right: 100,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6)
                    ],
                  ),
                  child: Text(
                    "Distance: ${controller.distanceInKm.toStringAsFixed(2)} km\n"
                    "ETA: ${controller.hours}h ${controller.minutes}m ${controller.seconds}s",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
