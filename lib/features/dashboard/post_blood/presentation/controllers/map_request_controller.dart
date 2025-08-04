import 'dart:async';
import 'dart:convert';

import 'package:blood_donor/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/auth/data/models/user_model.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/Dashboatd.dart';
import 'package:blood_donor/features/dashboard/post_blood/data/models/user_location_model.dart';
import 'package:blood_donor/features/dashboard/post_blood/domain/repository_post_request.dart';
import 'package:blood_donor/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class MapRequestController extends GetxController {
  final RepositoryPostRequest _postRequest = RepositoryPostRequest();
  final Map<String, dynamic> payload;
  final Completer<GoogleMapController> controller;
  final List<UserModel> userList;
  final List<UserLocationModel> locationList;
  MapRequestController(
      {required this.payload,
      required this.controller,
      required this.userList,
      required this.locationList});
  Completer<GoogleMapController> controller1 = Completer<GoogleMapController>();
  List<Map<String, double>> receiverLocations = [];
  List<String> nearbyDonors = [];
  Set<Marker> markers = {};
  bool isUrdu = false;

  @override
  void onInit() {
    if (!controller1.isCompleted) {
      controller1 = controller;
    } else {
      controller1 = Completer<GoogleMapController>();
    }
    donorOnMap();
    super.onInit();
  }

  Future<void> justPostRequest() async {
    try {
      bool result = await postBloodRequest(payload);
      if (result) {
        _showDonatePopup();
      }
    } catch (e) {
    } finally {
      await EasyLoading.dismiss();
    }
  }

  // Future<void> donorOnMap() async {
  //   try {
  //     // Fetch all donor locations from Firestore
  //     QuerySnapshot donorSnapshot =
  //         await FirebaseFirestore.instance.collection('donor_location').get();

  //     if (donorSnapshot.docs.isNotEmpty) {
  //       List<String> receiverIds = [];
  //       List<Map<String, double>> receiverLocs = [];
  //       Set<Marker> newMarkers = {};

  //       // Get taker location from the widget
  //       List<String> extraLocations = [payload['location']];
  //       Location takerLocation =
  //           (await locationFromAddress(payload['location'])).first;

  //       // Get the file path for saving the data
  //       Directory directory = await getApplicationDocumentsDirectory();
  //       File donorFile = File('${directory.path}/nearby_donors.txt');

  //       // Ensure file exists
  //       if (!await donorFile.exists()) {
  //         await donorFile.create();
  //       }

  //       // Iterate over each donor document
  //       for (var doc in donorSnapshot.docs) {
  //         String donorLocation = doc['donor_location'];
  //         String donorId =
  //             doc['user_id']; // Assuming you have donor_id or some identifier

  //         // Convert donorLocation to latitude and longitude
  //         List<Location> locations = await locationFromAddress(donorLocation);
  //         if (locations.isNotEmpty) {
  //           Location loc = locations.first;

  //           // Add marker for donor location
  //           newMarkers.add(Marker(
  //             markerId: MarkerId(donorLocation),
  //             position: LatLng(loc.latitude, loc.longitude),
  //             infoWindow: InfoWindow(title: donorLocation),
  //           ));

  //           // Calculate distance between taker location and donor location
  //           double distanceInMeters = Geolocator.distanceBetween(
  //               takerLocation.latitude,
  //               takerLocation.longitude,
  //               loc.latitude,
  //               loc.longitude);

  //           double distanceInKm = distanceInMeters / 1000;

  //           // Check if the distance is within 5 km
  //           if (distanceInKm <= 5) {
  //             receiverIds.add(donorLocation);
  //             receiverLocs
  //                 .add({'latitude': loc.latitude, 'longitude': loc.longitude});

  //             // Add to nearby donors list for notification
  //             nearbyDonors.add(donorLocation);

  //             // Add donor details to the file
  //             await donorFile.writeAsString(
  //               'Donor ID: $donorId, Location: $donorLocation, Distance: ${distanceInKm.toStringAsFixed(2)} km\n',
  //               mode: FileMode.append,
  //             );
  //           }
  //         }
  //       }

  //       for (String extraLocation in extraLocations) {
  //         List<Location> locations = await locationFromAddress(extraLocation);
  //         if (locations.isNotEmpty) {
  //           Location loc = locations.first;
  //           receiverLocs
  //               .add({'latitude': loc.latitude, 'longitude': loc.longitude});

  //           // Add marker for taker location
  //           newMarkers.add(Marker(
  //             markerId: MarkerId(extraLocation),
  //             position: LatLng(loc.latitude, loc.longitude),
  //             infoWindow: InfoWindow(title: extraLocation),
  //           ));

  //           // Animate camera to the taker location
  //           final GoogleMapController controllers = await controller.future;
  //           controllers.animateCamera(
  //             CameraUpdate.newLatLngZoom(
  //               LatLng(loc.latitude, loc.longitude),
  //               10.0, // Adjust zoom level as needed
  //             ),
  //           );
  //         }
  //       }

  //       receiverIds = receiverIds;
  //       receiverLocations = receiverLocs;
  //       markers = newMarkers;
  //       update();

  //       logSuccess('Nearby donors saved to file.');
  //     } else {
  //       logError('No donors found.');
  //     }
  //   } catch (e) {
  //     logError(e.toString());
  //   }
  // }
  // Future<void> donorOnMap() async {
  //   try {
  //     showLoader('please wait...');
  //     final donorSnapshot =
  //         await FirebaseFirestore.instance.collection('donor_location').get();

  //     if (donorSnapshot.docs.isEmpty) {
  //       logError('No donors found.');
  //       return;
  //     }

  //     final extraLocation = payload['location'];
  //     final List<Map<String, double>> receiverLocs = [];
  //     final Set<Marker> newMarkers = {};
  //     final List<String> receiverIds = [];

  //     final takerLocation = (await locationFromAddress(extraLocation)).first;
  //     final directory = await getApplicationDocumentsDirectory();
  //     final donorFile = File('${directory.path}/nearby_donors.txt');

  //     if (!await donorFile.exists()) await donorFile.create();

  //     // Convert all donors to futures and process in parallel
  //     final futures = donorSnapshot.docs.map((doc) async {
  //       final donorLocation = doc['donor_location'];
  //       final donorId = doc['user_id'];

  //       try {
  //         final locations = await locationFromAddress(donorLocation);
  //         if (locations.isEmpty) return;

  //         final loc = locations.first;
  //         final distanceInMeters = Geolocator.distanceBetween(
  //             takerLocation.latitude,
  //             takerLocation.longitude,
  //             loc.latitude,
  //             loc.longitude);
  //         final distanceInKm = distanceInMeters / 1000;

  //         // Add marker regardless of distance
  //         newMarkers.add(Marker(
  //           markerId: MarkerId(donorLocation),
  //           position: LatLng(loc.latitude, loc.longitude),
  //           infoWindow: InfoWindow(title: donorLocation),
  //         ));

  //         if (distanceInKm <= 5) {
  //           receiverIds.add(donorLocation);
  //           receiverLocs
  //               .add({'latitude': loc.latitude, 'longitude': loc.longitude});
  //           nearbyDonors.add(donorLocation);

  //           await donorFile.writeAsString(
  //             'Donor ID: $donorId, Location: $donorLocation, Distance: ${distanceInKm.toStringAsFixed(2)} km\n',
  //             mode: FileMode.append,
  //           );
  //         }
  //       } catch (e) {
  //         logError(
  //             'Failed to process donor location: $donorLocation | Error: $e');
  //       }
  //     });

  //     await Future.wait(futures); // Run all donor processing in parallel

  //     // Process receiver (taker) location
  //     final receiverLoc =
  //         LatLng(takerLocation.latitude, takerLocation.longitude);
  //     receiverLocs.add({
  //       'latitude': receiverLoc.latitude,
  //       'longitude': receiverLoc.longitude
  //     });
  //     newMarkers.add(Marker(
  //       markerId: MarkerId(extraLocation),
  //       position: receiverLoc,
  //       infoWindow: InfoWindow(title: extraLocation),
  //     ));

  //     // Animate map to taker location
  //     final GoogleMapController controllers = await controller.future;
  //     await controllers
  //         .animateCamera(CameraUpdate.newLatLngZoom(receiverLoc, 10.0));

  //     // Update state
  //     receiverLocations = receiverLocs;
  //     markers = newMarkers;
  //     update();

  //     logSuccess('Nearby donors saved to file.');
  //   } catch (e) {
  //     logError('Error in donorOnMap(): $e');
  //   } finally {
  //     await EasyLoading.dismiss();
  //   }
  // }

  Future<void> donorOnMap() async {
    try {
      showLoader('Please wait...');

      if (locationList.isEmpty) {
        logError('No donors found.');
        return;
      }

      final extraLocation = payload['location'];
      final takerLocation = (await locationFromAddress(extraLocation)).first;

      final Set<Marker> newMarkers = {};
      final List<Map<String, double>> receiverLocs = [];
      final List<String> receiverIds = [];
      final List<String> nearbyDonorLogLines = [];

      final futures = locationList.map((donor) async {
        try {
          final address = donor.userLcoation.toString().trim();
          if (address.isEmpty) {
            logError('❌ Skipping donor with empty location.');
            return;
          }

          final locations = await locationFromAddress(address);
          if (locations.isEmpty) {
            logError('❌ No results for location: $address');
            return;
          }

          final loc = locations.first;
          final distanceInMeters = Geolocator.distanceBetween(
            takerLocation.latitude,
            takerLocation.longitude,
            loc.latitude,
            loc.longitude,
          );
          final distanceInKm = distanceInMeters / 1000;

          newMarkers.add(Marker(
            markerId: MarkerId(address),
            position: LatLng(loc.latitude, loc.longitude),
            infoWindow: InfoWindow(title: address),
          ));

          if (distanceInKm <= 5) {
            receiverIds.add(donor.userId); // More meaningful than location
            receiverLocs
                .add({'latitude': loc.latitude, 'longitude': loc.longitude});
            nearbyDonors.add(address);

            nearbyDonorLogLines.add(
              'Donor ID: ${donor.userId}, Location: $address, Distance: ${distanceInKm.toStringAsFixed(2)} km',
            );
          }
        } catch (e) {
          logError('❌ Error processing ${donor.userId}: $e');
        }
      }).toList();

      await Future.wait(futures);

      final receiverLoc =
          LatLng(takerLocation.latitude, takerLocation.longitude);
      newMarkers.add(Marker(
        markerId: MarkerId(extraLocation),
        position: receiverLoc,
        infoWindow: InfoWindow(title: extraLocation),
      ));
      receiverLocs.add({
        'latitude': receiverLoc.latitude,
        'longitude': receiverLoc.longitude,
      });

      // Move camera
      final GoogleMapController controllers = await controller1.future;
      await controllers
          .animateCamera(CameraUpdate.newLatLngZoom(receiverLoc, 10.0));

      receiverLocations = receiverLocs;
      markers = newMarkers;
      update();

      logSuccess('Nearby donors saved to file.');
    } catch (e) {
      logError('Error in donorOnMap(): $e');
    } finally {
      await EasyLoading.dismiss();
    }
  }

  // Future<void> getDonorLocation10KM() async {
  //   try {
  //     showLoader("please wait...");
  //     showLoader("please wait...");

  //     // Fetch all donor locations at once
  //     final donorSnapshot =
  //         await FirebaseFirestore.instance.collection('donor_location').get();

  //     if (donorSnapshot.docs.isEmpty) {
  //       logError('No donors found.');
  //       return;
  //     }

  //     final List<String> nearbyDonors = [];
  //     final List<Map<String, double>> receiverLocs = [];
  //     final List<Future<void>> locationFutures = [];

  //     // Process taker location first
  //     final takerAddress = payload['location'];
  //     final takerLocation = (await locationFromAddress(takerAddress)).first;
  //     final takerLat = takerLocation.latitude;
  //     final takerLng = takerLocation.longitude;

  //     receiverLocs.add({'latitude': takerLat, 'longitude': takerLng});

  //     // Move map camera to taker
  //     final controller1 = await controller.future;
  //     controller1.animateCamera(
  //         CameraUpdate.newLatLngZoom(LatLng(takerLat, takerLng), 10.0));

  //     // Process donor locations in parallel using Futures
  //     for (var doc in donorSnapshot.docs) {
  //       final donorAddress = doc['donor_location'];

  //       locationFutures.add(() async {
  //         try {
  //           final donorLocList = await locationFromAddress(donorAddress);
  //           if (donorLocList.isNotEmpty) {
  //             final donorLoc = donorLocList.first;
  //             final distanceInMeters = Geolocator.distanceBetween(
  //                 takerLat, takerLng, donorLoc.latitude, donorLoc.longitude);

  //             if ((distanceInMeters / 1000) <= 10) {
  //               receiverLocs.add({
  //                 'latitude': donorLoc.latitude,
  //                 'longitude': donorLoc.longitude
  //               });
  //               nearbyDonors.add(donorAddress);
  //             }
  //           }
  //         } catch (e) {
  //           logError("Geocoding failed for: $donorAddress → $e");
  //         }
  //       }());
  //     }

  //     Future.wait(locationFutures); // Wait for all geocoding in parallel

  //     receiverLocations = receiverLocs;
  //     update();

  //     logSuccess('Nearby donors located and ready.');
  //     await EasyLoading.dismiss();
  //     await sendNotificationsToNearbyDonors(nearbyDonors);
  //   } catch (e) {
  //     logError('Error: $e');
  //   } finally {}
  // }
  Future<void> getNearDonoesByLocations(int distance, int number) async {
    try {
      showLoader("please wait...");
      showLoader("please wait...");

      if (locationList.isNotEmpty) {
        List<String> receiverIds = [];
        List<Map<String, double>> receiverLocs = [];
        Set<Marker> newMarkers = {};

        // Get taker location from the widget
        List<String> extraLocations = [payload['location']];
        Location takerLocation =
            (await locationFromAddress(payload['location'])).first;

        // Iterate over each donor document
        for (var doc in locationList) {
          String donorLocation = doc.userLcoation;

          // Convert donorLocation to latitude and longitude
          List<Location> locations = await locationFromAddress(donorLocation);
          if (locations.isNotEmpty) {
            Location loc = locations.first;

            double distanceInMeters = Geolocator.distanceBetween(
                takerLocation.latitude,
                takerLocation.longitude,
                loc.latitude,
                loc.longitude);

            double distanceInKm = distanceInMeters / 1000;

            // Check if the distance is within 5 km
            if (distanceInKm <= distance) {
              receiverIds.add(donorLocation);
              receiverLocs
                  .add({'latitude': loc.latitude, 'longitude': loc.longitude});

              // Add to nearby donors list for notification
              nearbyDonors.add(donorLocation);
            }
          }
        }

        // Process the extra locations (taker location)
        for (String extraLocation in extraLocations) {
          List<Location> locations = await locationFromAddress(extraLocation);
          if (locations.isNotEmpty) {
            Location loc = locations.first;
            receiverLocs
                .add({'latitude': loc.latitude, 'longitude': loc.longitude});

            // Add marker for taker location
            // newMarkers.add(Marker(
            //   markerId: MarkerId(extraLocation),
            //   position: LatLng(loc.latitude, loc.longitude),
            //   infoWindow: InfoWindow(title: extraLocation),
            // ));

            // Animate camera to the taker location
            final GoogleMapController controller1 = await controller.future;
            controller1.animateCamera(
              CameraUpdate.newLatLngZoom(
                LatLng(loc.latitude, loc.longitude),
                10.0,
              ),
            );
          }
        }

        receiverIds = receiverIds;
        receiverLocations = receiverLocs;
        markers = newMarkers;
        update();

        logSuccess('Nearby donors saved to file.');
        await EasyLoading.dismiss();
        await sendNotificationsToNearbyDonors(nearbyDonors);
      } else {
        logError('No donors found.');
      }
    } catch (e) {
      logError('Error: $e');
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> getDonorLocation10KM() async {
    try {
      showLoader("please wait...");
      showLoader("please wait...");

      if (locationList.isNotEmpty) {
        List<String> receiverIds = [];
        List<Map<String, double>> receiverLocs = [];
        Set<Marker> newMarkers = {};

        // Get taker location from the widget
        List<String> extraLocations = [payload['location']];
        Location takerLocation =
            (await locationFromAddress(payload['location'])).first;

        // Iterate over each donor document
        for (var doc in locationList) {
          String donorLocation = doc.userLcoation;

          // Convert donorLocation to latitude and longitude
          List<Location> locations = await locationFromAddress(donorLocation);
          if (locations.isNotEmpty) {
            Location loc = locations.first;

            double distanceInMeters = Geolocator.distanceBetween(
                takerLocation.latitude,
                takerLocation.longitude,
                loc.latitude,
                loc.longitude);

            double distanceInKm = distanceInMeters / 1000;

            // Check if the distance is within 5 km
            if (distanceInKm <= 10) {
              receiverIds.add(donorLocation);
              receiverLocs
                  .add({'latitude': loc.latitude, 'longitude': loc.longitude});

              // Add to nearby donors list for notification
              nearbyDonors.add(donorLocation);
            }
          }
        }

        // Process the extra locations (taker location)
        for (String extraLocation in extraLocations) {
          List<Location> locations = await locationFromAddress(extraLocation);
          if (locations.isNotEmpty) {
            Location loc = locations.first;
            receiverLocs
                .add({'latitude': loc.latitude, 'longitude': loc.longitude});

            // Add marker for taker location
            // newMarkers.add(Marker(
            //   markerId: MarkerId(extraLocation),
            //   position: LatLng(loc.latitude, loc.longitude),
            //   infoWindow: InfoWindow(title: extraLocation),
            // ));

            // Animate camera to the taker location
            final GoogleMapController controller1 = await controller.future;
            controller1.animateCamera(
              CameraUpdate.newLatLngZoom(
                LatLng(loc.latitude, loc.longitude),
                10.0, // Adjust zoom level as needed
              ),
            );
          }
        }

        receiverIds = receiverIds;
        receiverLocations = receiverLocs;
        markers = newMarkers;
        update();

        logSuccess('Nearby donors saved to file.');
        await sendNotificationsToNearbyDonors(nearbyDonors);
      } else {
        logError('No donors found.');
      }
    } catch (e) {
      logError('Error: $e');
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> getDonorLocation15KM() async {
    try {
      showLoader("please wait...");
      showLoader("please wait...");

      if (locationList.isNotEmpty) {
        List<String> receiverIds = [];
        List<Map<String, double>> receiverLocs = [];
        Set<Marker> newMarkers = {};

        // Get taker location from the widget
        List<String> extraLocations = [payload['location']];
        Location takerLocation =
            (await locationFromAddress(payload['location'])).first;

        for (var doc in locationList) {
          String donorLocation = doc.userLcoation;

          // Convert donorLocation to latitude and longitude
          List<Location> locations = await locationFromAddress(donorLocation);
          if (locations.isNotEmpty) {
            Location loc = locations.first;

            // Add marker for donor location
            newMarkers.add(Marker(
              markerId: MarkerId(donorLocation),
              position: LatLng(loc.latitude, loc.longitude),
              infoWindow: InfoWindow(title: donorLocation),
            ));

            // Calculate distance between taker location and donor location
            double distanceInMeters = Geolocator.distanceBetween(
                takerLocation.latitude,
                takerLocation.longitude,
                loc.latitude,
                loc.longitude);

            double distanceInKm = distanceInMeters / 1000;

            // Check if the distance is within 5 km
            if (distanceInKm <= 15) {
              receiverIds.add(donorLocation);
              receiverLocs
                  .add({'latitude': loc.latitude, 'longitude': loc.longitude});

              // Add to nearby donors list for notification
              nearbyDonors.add(donorLocation);
            }
          }
        }

        // Process the extra locations (taker location)
        for (String extraLocation in extraLocations) {
          List<Location> locations = await locationFromAddress(extraLocation);
          if (locations.isNotEmpty) {
            Location loc = locations.first;
            receiverLocs
                .add({'latitude': loc.latitude, 'longitude': loc.longitude});

            newMarkers.add(Marker(
              markerId: MarkerId(extraLocation),
              position: LatLng(loc.latitude, loc.longitude),
              infoWindow: InfoWindow(title: extraLocation),
            ));

            // Animate camera to the taker location
            final GoogleMapController controller1 = await controller.future;
            controller1.animateCamera(
              CameraUpdate.newLatLngZoom(
                LatLng(loc.latitude, loc.longitude),
                10.0, // Adjust zoom level as needed
              ),
            );
          }
        }

        receiverIds = receiverIds;
        receiverLocations = receiverLocs;
        markers = newMarkers;
        update();

        logSuccess('Nearby donors saved to file.');
        await sendNotificationsToNearbyDonors(nearbyDonors);
      } else {
        logError('No donors found.');
      }
    } catch (e) {
      logError('Error: $e');
    } finally {
      await EasyLoading.dismiss();
    }
  }
  // Future<void> getDonorLocation15KM() async {
  //   try {
  //     showLoader("please wait...");
  //     showLoader("please wait...");

  //     // Fetch all donor locations
  //     final donorSnapshot =
  //         await FirebaseFirestore.instance.collection('donor_location').get();

  //     if (donorSnapshot.docs.isEmpty) {
  //       logError('No donors found.');
  //       return;
  //     }

  //     final List<Map<String, double>> receiverLocs = [];
  //     final Set<Marker> newMarkers = {};
  //     final List<Future<void>> locationFutures = [];

  //     final String takerAddress = payload['location'];
  //     final Location takerLoc = (await locationFromAddress(takerAddress)).first;

  //     final double takerLat = takerLoc.latitude;
  //     final double takerLng = takerLoc.longitude;

  //     receiverLocs.add({'latitude': takerLat, 'longitude': takerLng});

  //     // Add taker marker
  //     newMarkers.add(Marker(
  //       markerId: MarkerId('taker_location'),
  //       position: LatLng(takerLat, takerLng),
  //       infoWindow: InfoWindow(title: takerAddress),
  //     ));

  //     // Animate camera to taker location
  //     final GoogleMapController controller1 = await controller.future;
  //     controller1.animateCamera(
  //       CameraUpdate.newLatLngZoom(LatLng(takerLat, takerLng), 10.0),
  //     );

  //     // Parallel geocode donor locations
  //     for (var doc in donorSnapshot.docs) {
  //       final String donorAddress = doc['donor_location'];

  //       locationFutures.add(() async {
  //         try {
  //           final donorLocList = await locationFromAddress(donorAddress);
  //           if (donorLocList.isEmpty) return;

  //           final Location donorLoc = donorLocList.first;
  //           final double distanceInKm = Geolocator.distanceBetween(
  //                 takerLat,
  //                 takerLng,
  //                 donorLoc.latitude,
  //                 donorLoc.longitude,
  //               ) /
  //               1000;

  //           // Add marker for all donors
  //           newMarkers.add(Marker(
  //             markerId: MarkerId(donorAddress),
  //             position: LatLng(donorLoc.latitude, donorLoc.longitude),
  //             infoWindow: InfoWindow(title: donorAddress),
  //           ));

  //           // Save nearby donors
  //           if (distanceInKm <= 15) {
  //             receiverLocs.add({
  //               'latitude': donorLoc.latitude,
  //               'longitude': donorLoc.longitude
  //             });
  //             nearbyDonors.add(donorAddress);
  //           }
  //         } catch (e) {
  //           logError("Failed to geocode $donorAddress: $e");
  //         }
  //       }());
  //     }

  //     Future.wait(locationFutures); // wait for all donors to be processed

  //     // Set values
  //     receiverLocations = receiverLocs;
  //     markers = newMarkers;
  //     update();

  //     logSuccess('Nearby donors saved.');
  //     await EasyLoading.dismiss();
  //     await sendNotificationsToNearbyDonors(nearbyDonors);
  //   } catch (e) {
  //     logError('Error: $e');
  //   } finally {}
  // }

  Future<void> getDonorLocation20KM() async {
    try {
      showLoader("Please Wait!");
      showLoader("please wait...");

      if (locationList.isNotEmpty) {
        List<String> receiverIds = [];
        List<Map<String, double>> receiverLocs = [];
        Set<Marker> newMarkers = {};

        // Get taker location from the widget
        List<String> extraLocations = [payload['location']];
        Location takerLocation =
            (await locationFromAddress(payload['location'])).first;

        // Iterate over each donor document
        for (var doc in locationList) {
          String donorLocation = doc.userLcoation;

          // Convert donorLocation to latitude and longitude
          List<Location> locations = await locationFromAddress(donorLocation);
          if (locations.isNotEmpty) {
            Location loc = locations.first;

            // Add marker for donor location
            newMarkers.add(Marker(
              markerId: MarkerId(donorLocation),
              position: LatLng(loc.latitude, loc.longitude),
              infoWindow: InfoWindow(title: donorLocation),
            ));

            // Calculate distance between taker location and donor location
            double distanceInMeters = Geolocator.distanceBetween(
                takerLocation.latitude,
                takerLocation.longitude,
                loc.latitude,
                loc.longitude);

            double distanceInKm = distanceInMeters / 1000;

            // Check if the distance is within 5 km
            if (distanceInKm <= 20) {
              receiverIds.add(donorLocation);
              receiverLocs
                  .add({'latitude': loc.latitude, 'longitude': loc.longitude});

              // Add to nearby donors list for notification
              nearbyDonors.add(donorLocation);

              // Add donor details to the file
            }
          }
        }

        // Process the extra locations (taker location)
        for (String extraLocation in extraLocations) {
          List<Location> locations = await locationFromAddress(extraLocation);
          if (locations.isNotEmpty) {
            Location loc = locations.first;
            receiverLocs
                .add({'latitude': loc.latitude, 'longitude': loc.longitude});

            // Add marker for taker location
            newMarkers.add(Marker(
              markerId: MarkerId(extraLocation),
              position: LatLng(loc.latitude, loc.longitude),
              infoWindow: InfoWindow(title: extraLocation),
            ));

            // Animate camera to the taker location
            final GoogleMapController controller1 = await controller.future;
            controller1.animateCamera(
              CameraUpdate.newLatLngZoom(
                LatLng(loc.latitude, loc.longitude),
                10.0, // Adjust zoom level as needed
              ),
            );
          }
        }

        receiverIds = receiverIds;
        receiverLocations = receiverLocs;
        markers = newMarkers;
        update();

        logSuccess('Nearby donors saved to file.');
        await sendNotificationsToNearbyDonors(nearbyDonors);
      } else {
        logError('No donors found.');
      }
    } catch (e) {
      logError('Error: $e');
    } finally {
      await EasyLoading.dismiss();
    }
  }
  // Future<void> getDonorLocation20KM() async {
  //   try {
  //     showLoader("please wait...");
  //     showLoader("please wait...");

  //     // Fetch all donor locations from Firestore
  //     final donorSnapshot =
  //         await FirebaseFirestore.instance.collection('donor_location').get();
  //     if (donorSnapshot.docs.isEmpty) {
  //       logError('No donors found.');
  //       return;
  //     }

  //     final List<Map<String, double>> receiverLocs = [];
  //     final Set<Marker> newMarkers = {};
  //     final List<Future<void>> geocodeTasks = [];

  //     // Get taker location from payload
  //     final String takerAddress = payload['location'];
  //     final Location takerLocation =
  //         (await locationFromAddress(takerAddress)).first;
  //     final double takerLat = takerLocation.latitude;
  //     final double takerLng = takerLocation.longitude;

  //     // Add taker location to receiverLocs and markers
  //     receiverLocs.add({'latitude': takerLat, 'longitude': takerLng});
  //     newMarkers.add(Marker(
  //       markerId: MarkerId(takerAddress),
  //       position: LatLng(takerLat, takerLng),
  //       infoWindow: InfoWindow(title: takerAddress),
  //     ));

  //     // Animate camera to taker location once
  //     final GoogleMapController controller1 = await controller.future;
  //     controller1.animateCamera(CameraUpdate.newLatLngZoom(
  //       LatLng(takerLat, takerLng),
  //       10.0,
  //     ));

  //     // Geocode all donor locations in parallel
  //     for (var doc in donorSnapshot.docs) {
  //       final String donorAddress = doc['donor_location'];

  //       geocodeTasks.add(() async {
  //         try {
  //           final locs = await locationFromAddress(donorAddress);
  //           if (locs.isEmpty) return;

  //           final donorLoc = locs.first;
  //           final double distanceKm = Geolocator.distanceBetween(
  //                 takerLat,
  //                 takerLng,
  //                 donorLoc.latitude,
  //                 donorLoc.longitude,
  //               ) /
  //               1000;

  //           newMarkers.add(Marker(
  //             markerId: MarkerId(donorAddress),
  //             position: LatLng(donorLoc.latitude, donorLoc.longitude),
  //             infoWindow: InfoWindow(title: donorAddress),
  //           ));

  //           if (distanceKm <= 20) {
  //             receiverLocs.add({
  //               'latitude': donorLoc.latitude,
  //               'longitude': donorLoc.longitude,
  //             });
  //             nearbyDonors.add(donorAddress);
  //           }
  //         } catch (e) {
  //           logError('Failed to geocode $donorAddress: $e');
  //         }
  //       }());
  //     }

  //     Future.wait(geocodeTasks);

  //     // Update state
  //     receiverLocations = receiverLocs;
  //     markers = newMarkers;
  //     update();

  //     logSuccess('Nearby donors saved.');
  //     await EasyLoading.dismiss();
  //     await sendNotificationsToNearbyDonors(nearbyDonors);
  //   } catch (e) {
  //     logError('Error: $e');
  //   } finally {}
  // }

  Future<void> sendNotificationsToNearbyDonors(
      List<String> nearbyLocations) async {
    try {
      // showLoader("please wait...");
      if (nearbyLocations.isEmpty) {
        // Show CupertinoActionSheet if nearbyLocations is empty
        await showCupertinoModalPopup<void>(
          context: navigatorKey.currentContext!,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              title: Text('No nearby donors found'),
              message: Text('Choose a distance range to search for donors.'),
              actions: <CupertinoActionSheetAction>[
                CupertinoActionSheetAction(
                  onPressed: () async {
                    // Action for 10km
                    Navigator.pop(context, '10km');
                    await getNearDonoesByLocations(10, 1);
                    // Call your function to search within 10km
                  },
                  child: Text(
                    '10km',
                    style: TextStyle(color: PRIMARY_COLOR),
                  ),
                ),
                CupertinoActionSheetAction(
                  onPressed: () async {
                    Navigator.pop(context, '15km');
                    await getNearDonoesByLocations(15, 2);
                  },
                  child: Text(
                    '15km',
                    style: TextStyle(color: PRIMARY_COLOR),
                  ),
                ),
                CupertinoActionSheetAction(
                  onPressed: () async {
                    // Action for 20km
                    Navigator.pop(context, '20km');
                    await getNearDonoesByLocations(20, 3);
                    // Call your function to search within 20km
                  },
                  child: Text(
                    '20km',
                    style: TextStyle(color: PRIMARY_COLOR),
                  ),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    // Action for 20km
                    Navigator.pop(context, '30km');
                    getNearDonoesByLocations(30, 4);
                    // Call your function to search within 20km
                  },
                  child: Text(
                    '30km',
                    style: TextStyle(color: PRIMARY_COLOR),
                  ),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    // Action for 20km
                    Navigator.pop(context, '');
                    justPostRequest();
                    // Call your function to search within 20km
                  },
                  child: Text(
                    'Just Post',
                    style: TextStyle(color: PRIMARY_COLOR),
                  ),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  // Cancel action
                  Navigator.pop(context);
                },
                isDefaultAction: true,
                child: Text(
                  'Cancel',
                  style: TextStyle(color: PRIMARY_COLOR),
                ),
              ),
            );
          },
        );
      } else {
        showLoader('sending notification...');
        // If nearbyLocations is not empty, proceed with sending notifications
        String projectId = 'blood-app-8f4c2';

        List<String> list = [];
        List<String> nonDuplicateList = [];

        for (String location in nearbyLocations) {
          for (var userDoc in locationList) {
            if (location == userDoc.userLcoation) {
              String userId = userDoc.userId;
              list.add(userId);
              Set<String> uniqueList = list.toSet();
              nonDuplicateList = uniqueList.toList();
            }
          }
        }
        for (String userId in nonDuplicateList) {
          for (var i = 0; i < userList.length; i++) {
            if (userList[i].id == userId) {
              var data = {
                'message': {
                  'token': userList[i].deviceToken,
                  'notification': {
                    'title': 'New Blood Request',
                    'body':
                        'You have a new blood request from ${payload['name']} for blood ${payload['blood']}.'
                  },
                  'apns': {
                    'payload': {
                      'aps': {
                        'sound': 'custom_sound.wav',
                      }
                    }
                  },
                  'data': {'type': 'request_notification', 'id': 'Nomi12345'}
                }
              };

              var jsonString =
                  await rootBundle.loadString('images/json/key1.json');
              var clientCredentials =
                  auth.ServiceAccountCredentials.fromJson(jsonString);
              var scopes = [
                'https://www.googleapis.com/auth/firebase.messaging'
              ];
              var client =
                  await auth.clientViaServiceAccount(clientCredentials, scopes);

              var response = await http.post(
                Uri.parse(
                    'https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
                headers: {
                  'Authorization':
                      'Bearer ${client.credentials.accessToken.data}',
                  'Content-Type': 'application/json',
                },
                body: jsonEncode(data),
              );

              if (response.statusCode == 200) {
                EasyLoading.dismiss();
                logSuccess(
                    'Notification sent successfully to user: ${userList[i].id}');
              } else {
                logError(
                    'Failed to send notification to user: ${userList[i].id} Status code: ${response.statusCode}');
                logError('Response body: ${response.body}');
                await EasyLoading.dismiss();
              }
            }
          }
        }

        bool result = await postBloodRequest(payload);
        if (result) {
          _showDonatePopup();
        }
      }
    } catch (e) {
      logError('Error sending notification: $e');
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<bool> postBloodRequest(Map<String, dynamic> payload) async {
    try {
      showLoader('adding request...');
      return await _postRequest.postBloodRequest(payload);
    } catch (e) {
      Helper.handleError(e, 'Error while post blood requst!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  void _showDonatePopup() {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return GetBuilder<MapRequestController>(builder: (homeController) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            backgroundColor: Colors.white,
            title: Center(
              child: Column(
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                    onTap: () {
                      isUrdu = !isUrdu;
                      update();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: PRIMARY_COLOR,
                        border: Border.all(color: PRIMARY_COLOR),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        isUrdu ? 'Switch to English' : 'Switch to Urdu',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Image.asset(
                    'images/svg1.png',
                    height: 30.h,
                    width: 30.w,
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
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Blood is Successfully Requested',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                isUrdu
                    ? Text(
                        'نوٹ: ڈونر کسی بھی قسم کی رقم لینے یا مانگنے کا ذمہ دار نہیں ہے۔\n'
                        'جب ڈونر کامیابی سے خون عطیہ کر دیتا ہے، تو ایڈمن کی جانب سے آنے والے دنوں میں شکریہ کے طور پر ایک واؤچر جاری کیا جائے گا۔\n'
                        'یہ واؤچر منتخب شدہ ریسٹورنٹس، کپڑوں کی دکانوں اور دیگر پارٹنر آؤٹ لیٹس پر استعمال کیا جا سکتا ہے۔',
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    : Text(
                        'Note: The donor is not responsible for requesting or accepting any kind of money from the recipient. '
                        'Once the donor has successfully donated blood, a voucher will be issued by the admin in the coming days as a token of appreciation. '
                        'This voucher may be used at selected restaurants, clothing stores, and other partnered outlets.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 12, color: Colors.black),
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
        });
      },
    );
  }
}
