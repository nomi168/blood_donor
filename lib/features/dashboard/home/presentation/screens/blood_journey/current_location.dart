import 'package:blood_donor/features/dashboard/home/data/models/donor_accept_model.dart';
import 'package:blood_donor/features/dashboard/home/presentation/controllers/current_location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocationScreen extends StatelessWidget {
  final DonateAcceptModel model;
  const CurrentLocationScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(CurrentLocationController(model: model));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor → Taker Direction'),
        backgroundColor: Colors.white,
      ),
      body: GetBuilder<CurrentLocationController>(
        builder: (_) {
          return Stack(
            children: [
              /// Google Map
              Positioned.fill(
                child: GoogleMap(
                  onMapCreated: (mapController) {
                    if (!controller.controllers.isCompleted) {
                      controller.controllers.complete(mapController);
                    }
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  polylines: controller.polylines,
                  circles: controller.circles,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(31.5820, 74.3294), // Lahore fallback
                    zoom: 12,
                  ),
                ),
              ),

              /// Directions Input Panel
              if (controller.showDirections.value)
                Positioned(
                  top: 15,
                  left: 10,
                  right: 10,
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: controller.sourceController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Source (Current Location)',
                              prefixIcon: Icon(Icons.my_location),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: controller.destinationController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Destination (Donor Location)',
                              prefixIcon: Icon(Icons.location_on),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () => controller.getCurrentLocation(),
                            icon: const Icon(
                              Icons.directions,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Show Route',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              Obx(() {
                return Positioned(
                  bottom: 10,
                  right: 100,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 6)
                      ],
                    ),
                    child: Text(
                      "Distance: ${controller.distanceInKm.value.toStringAsFixed(2)} km\n"
                      "ETA: ${controller.hours.value}h ${controller.minutes.value}m ${controller.seconds.value}s",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }),

              /// Toggle Button
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  backgroundColor: Colors.redAccent,
                  onPressed: () {
                    controller.showDirections.toggle();
                    controller.update();
                  },
                  child: Obx(() => Icon(controller.showDirections.value
                      ? Icons.close
                      : Icons.directions)),
                ),
              ),

              /// Distance + ETA Info
              // if (controller.distanceInKm > 0)
              //   Positioned(
              //     bottom: 90,
              //     left: 20,
              //     right: 20,
              //     child: Container(
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 16, vertical: 10),
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(10),
              //         boxShadow: const [
              //           BoxShadow(
              //             color: Colors.black12,
              //             blurRadius: 6,
              //           ),
              //         ],
              //       ),
              //       child: Text(
              //         "Distance: ${controller.distanceInKm.toStringAsFixed(2)} km\nETA: ${controller.hours}h ${controller.minutes}m ${controller.seconds}s",
              //         style: const TextStyle(fontSize: 16),
              //       ),
              //     ),
              //   ),
            ],
          );
        },
      ),
    );
  }
}
