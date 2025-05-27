import 'dart:async';
import 'dart:convert';

import 'package:blood_donor/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/Dashboatd.dart';
import 'package:blood_donor/features/dashboard/post_blood/domain/repository_post_request.dart';
import 'package:blood_donor/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  MapRequestController({required this.payload, required this.controller});
  Completer<GoogleMapController> controller1 = Completer<GoogleMapController>();
  List<Map<String, double>> receiverLocations = [];
  List<String> nearbyDonors = [];
  Set<Marker> markers = {};

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

      final donorSnapshot =
          await FirebaseFirestore.instance.collection('donor_location').get();
      if (donorSnapshot.docs.isEmpty) {
        logError('No donors found.');
        return;
      }

      final extraLocation = payload['location'];
      final takerLocation = (await locationFromAddress(extraLocation)).first;

      // final directory = await getApplicationDocumentsDirectory();
      // final donorFile = File('${directory.path}/nearby_donors.txt');
      // if (await donorFile.exists()) await donorFile.delete();
      // await donorFile.create();

      final List<Map<String, dynamic>> donors = donorSnapshot.docs.map((doc) {
        return {
          'location': doc['donor_location'],
          'userId': doc['user_id'],
        };
      }).toList();

      final Set<Marker> newMarkers = {};
      final List<Map<String, double>> receiverLocs = [];
      final List<String> receiverIds = [];
      final List<String> nearbyDonorLogLines = [];

      final futures = donors.map((donor) async {
        try {
          final locations = await locationFromAddress(donor['location']);
          if (locations.isEmpty) return;

          final loc = locations.first;
          final distanceInMeters = Geolocator.distanceBetween(
            takerLocation.latitude,
            takerLocation.longitude,
            loc.latitude,
            loc.longitude,
          );
          final distanceInKm = distanceInMeters / 1000;

          newMarkers.add(Marker(
            markerId: MarkerId(donor['location']),
            position: LatLng(loc.latitude, loc.longitude),
            infoWindow: InfoWindow(title: donor['location']),
          ));

          if (distanceInKm <= 5) {
            receiverIds.add(donor['location']);
            receiverLocs
                .add({'latitude': loc.latitude, 'longitude': loc.longitude});
            nearbyDonors.add(donor['location']);

            nearbyDonorLogLines.add(
              'Donor ID: ${donor['userId']}, Location: ${donor['location']}, Distance: ${distanceInKm.toStringAsFixed(2)} km',
            );
          }
        } catch (e) {
          logError('Error processing ${donor['location']}: $e');
        }
      }).toList();

      await Future.wait(futures);

      // Write all nearby donors to file at once
      // await donorFile.writeAsString(nearbyDonorLogLines.join('\n'));

      // Add receiver marker
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

  Future<void> getDonorLocation10KM() async {
    try {
      showLoader("please wait...");
      showLoader("please wait...");
      // Fetch all donor locations from Firestore
      QuerySnapshot donorSnapshot =
          await FirebaseFirestore.instance.collection('donor_location').get();

      if (donorSnapshot.docs.isNotEmpty) {
        List<String> receiverIds = [];
        List<Map<String, double>> receiverLocs = [];
        Set<Marker> newMarkers = {};

        // Get taker location from the widget
        List<String> extraLocations = [payload['location']];
        Location takerLocation =
            (await locationFromAddress(payload['location'])).first;

        // Iterate over each donor document
        for (var doc in donorSnapshot.docs) {
          String donorLocation = doc['donor_location'];

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
      showLoader("Please Wait!");
      // Fetch all donor locations from Firestore
      QuerySnapshot donorSnapshot =
          await FirebaseFirestore.instance.collection('donor_location').get();

      if (donorSnapshot.docs.isNotEmpty) {
        List<String> receiverIds = [];
        List<Map<String, double>> receiverLocs = [];
        Set<Marker> newMarkers = {};

        // Get taker location from the widget
        List<String> extraLocations = [payload['location']];
        Location takerLocation =
            (await locationFromAddress(payload['location'])).first;

        for (var doc in donorSnapshot.docs) {
          String donorLocation = doc['donor_location'];

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

  Future<void> getDonorLocation20KM() async {
    try {
      showLoader("Please Wait!");
      showLoader("please wait...");
      // Fetch all donor locations from Firestore
      QuerySnapshot donorSnapshot =
          await FirebaseFirestore.instance.collection('donor_location').get();

      if (donorSnapshot.docs.isNotEmpty) {
        List<String> receiverIds = [];
        List<Map<String, double>> receiverLocs = [];
        Set<Marker> newMarkers = {};

        // Get taker location from the widget
        List<String> extraLocations = [payload['location']];
        Location takerLocation =
            (await locationFromAddress(payload['location'])).first;

        // Iterate over each donor document
        for (var doc in donorSnapshot.docs) {
          String donorLocation = doc['donor_location'];

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

  Future<void> sendNotificationsToNearbyDonors(
      List<String> nearbyLocations) async {
    try {
      showLoader("please wait...");
      if (nearbyLocations.isEmpty) {
        EasyLoading.dismiss();
        // Show CupertinoActionSheet if nearbyLocations is empty
        await showCupertinoModalPopup<void>(
          context: navigatorKey.currentContext!,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              title: Text('No nearby donors found'),
              message: Text('Choose a distance range to search for donors.'),
              actions: <CupertinoActionSheetAction>[
                CupertinoActionSheetAction(
                  onPressed: () {
                    // Action for 10km
                    Navigator.pop(context, '10km');
                    getDonorLocation10KM();
                    // Call your function to search within 10km
                  },
                  child: Text(
                    '10km',
                    style: TextStyle(color: PRIMARY_COLOR),
                  ),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    // Action for 15km
                    Navigator.pop(context, '15km');
                    getDonorLocation15KM();
                    // Call your function to search within 15km
                  },
                  child: Text(
                    '15km',
                    style: TextStyle(color: PRIMARY_COLOR),
                  ),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    // Action for 20km
                    Navigator.pop(context, '20km');
                    getDonorLocation20KM();
                    // Call your function to search within 20km
                  },
                  child: Text(
                    '20km',
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
        // If nearbyLocations is not empty, proceed with sending notifications
        String projectId = 'blood-app-8f4c2';

        List<String> list = [];
        List<String> nonDuplicateList = [];
        // Iterate over each location in the list
        for (String location in nearbyLocations) {
          // Query Firestore to get users in the current location
          QuerySnapshot userSnapshot = await FirebaseFirestore.instance
              .collection('donor_location')
              .where('donor_location', isEqualTo: location)
              .get();

          // Iterate over each user document in the query result
          for (QueryDocumentSnapshot userDoc in userSnapshot.docs) {
            String userId = userDoc['user_id'];
            list.add(userId);
            Set<String> uniqueList = list.toSet();
            nonDuplicateList = uniqueList.toList();
          }
        }
        for (String userId in nonDuplicateList) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

          if (userDoc.exists) {
            String deviceToken = userDoc['deviceToken'];
            String bloodType = userDoc['bloodgroup'];
            String type = userDoc['type'];
            if (payload['blood'] == bloodType && type == 'donor') {
              var data = {
                'message': {
                  'token': deviceToken,
                  'notification': {
                    'title': 'New Blood Request',
                    'body':
                        'You have a new blood request from ${payload['name']} for blood ${payload['blood']}.'
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
                logSuccess(
                    'Notification sent successfully to user: ${userDoc.id}');
              } else {
                logError(
                    'Failed to send notification to user: ${userDoc.id}. Status code: ${response.statusCode}');
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

  Future<bool> postBloodRequest(dynamic payload) async {
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
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          backgroundColor: Colors.white,
          title: Center(
            child: Column(
              children: [
                // Your image goes here
                Image.asset(
                  'images/svg1.png',
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
                'Blood is Successfully Requested',
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
