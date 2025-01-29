import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:blood_donor/Json%20Data/GoogleMapDark.dart';
import 'package:blood_donor/Screens/Main%20Screen/Dashoard/Dashboatd.dart';
import 'package:blood_donor/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class MapCheckScreen extends StatefulWidget {
  final String takerlocation;
  final String takerid;
  final String fullname;
  final String picture;
  final String takeremail;
  final String number;
  final String hospitalname;
  final String date;
  final String time;
  final String note;
  final String blood;
  final String rating;
  final bool status;
  const MapCheckScreen(
      {super.key,
      required this.takerlocation,
      required this.takerid,
      required this.fullname,
      required this.picture,
      required this.takeremail,
      required this.number,
      required this.hospitalname,
      required this.date,
      required this.time,
      required this.note,
      required this.blood,
      required this.rating,
      required this.status});

  @override
  State<MapCheckScreen> createState() => _MapCheckScreenState();
}

class _MapCheckScreenState extends State<MapCheckScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Set<Polygon> polygons = {};
  Set<Circle> circles = {};
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  Set<Marker> markers = {};
  bool isLightMode = false;
  List<dynamic> receiverIds = [];
  List<Map<String, double>> receiverLocations = [];
  List<String> nearbyDonors = [];
  String loc = '';
  @override
  void initState() {
    super.initState();
    loc = widget.takerlocation;

    getDonorLocation1();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        GoogleMap(
          myLocationButtonEnabled: true,
          minMaxZoomPreference: MinMaxZoomPreference.unbounded,
          mapToolbarEnabled: true,
          mapType: MapType.hybrid,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: markers,
          initialCameraPosition: CameraPosition(
              target: LatLng(0, 0), // Default position, adjust as needed
              zoom: 10 // Default zoom level, adjust as needed
              ),
        ),
        Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () async {
                sendNotificationsToNearbyDonors(nearbyDonors);
                // _showDistanceStepper(context);
                // sendNotificationsToNearbyDonors(nearbyDonors);
                await Future.delayed(Duration(seconds: 3));
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
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(Icons.circle_notifications_outlined)
                  ],
                ),
              ),
            ))
      ]),
    ));
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final GoogleMapController controller = await _controller.future;

      setState(() {
        circles.clear();
        circles.add(Circle(
          circleId: const CircleId('CurrentLocationCircle'),
          center: LatLng(position.latitude, position.longitude),
          radius: 120.0,
          fillColor: Colors.blue.withOpacity(0.3),
          strokeColor: Colors.blue,
          strokeWidth: 10,
        ));

        controller.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            9.6,
          ),
        );

        fromController.text =
            "${position.latitude.toString()}, ${position.longitude.toString()}";
      });
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
    }
  }

  Future<void> _goToCurrentLocation() async {
    _getCurrentLocation();
  }

  Future<void> showPath() async {
    try {
      String from = fromController.text;
      String to = toController.text;

      List<Location> fromLocations = await locationFromAddress(from);
      List<Location> toLocations = await locationFromAddress(to);

      if (fromLocations.isNotEmpty && toLocations.isNotEmpty) {
        Location fromLocation = fromLocations.first;

        // Let the user choose the correct "To" location from multiple results
        Location? toLocation = await _chooseLocation(toLocations);

        if (toLocation != null) {
          // ignore: unused_local_variable
          final GoogleMapController controller = await _controller.future;

          LatLng fromLatLng =
              LatLng(fromLocation.latitude, fromLocation.longitude);
          LatLng toLatLng = LatLng(toLocation.latitude, toLocation.longitude);

          // ignore: unused_local_variable
          LatLngBounds bounds = LatLngBounds(
            southwest: fromLatLng,
            northeast: toLatLng,
          );

          // Comment out the line below to prevent the camera from moving
          // controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));

          // ignore: unused_local_variable
          Polyline polyline = Polyline(
            polylineId: const PolylineId('Path'),
            color: Colors.red,
            points: [fromLatLng, toLatLng],
          );

          setState(() {
            circles.clear();
            circles.add(Circle(
              circleId: const CircleId('CurrentLocationCircle'),
              center: fromLatLng,
              radius: 120.0,
              fillColor: Colors.blue.withOpacity(0.3),
              strokeColor: Colors.blue,
              strokeWidth: 10,
            ));
            circles.add(Circle(
              circleId: const CircleId('DestinationCircle'),
              center: toLatLng,
              radius: 120.0,
              fillColor: Colors.green.withOpacity(0.3),
              strokeColor: Colors.green,
              strokeWidth: 10,
            ));
            polygons.clear();
            polygons.add(Polygon(
              polygonId: const PolygonId('PathPolygon'),
              points: [fromLatLng, toLatLng],
              fillColor: const Color(0xFFDE0A1E).withOpacity(0.5),
              strokeWidth: 2,
              strokeColor: const Color(0xFFDE0A1E),
            ));
          });

          // ignore: await_only_futures
          double distance = await Geolocator.distanceBetween(
            fromLocation.latitude,
            fromLocation.longitude,
            toLocation.latitude,
            toLocation.longitude,
          );

          double distanceInKm = distance / 1000;

          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Distance: ${distanceInKm.toStringAsFixed(2)} km'),
            ),
          );
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
    }
  }

  Future<Location?> _chooseLocation(List<Location> locations) async {
    // You can implement a UI to let the user choose the correct location
    // For simplicity, here we choose the first location from the list
    return locations.first;
  }

  Future<void> _toggleMapMode() async {
    final GoogleMapController controller = await _controller.future;
    controller.setMapStyle(isLightMode ? null : darkMapStyle);
  }

  Future<void> getdonorlocation() async {
    try {
      // Use the 'where' method to query documents with the specified email
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String userEmail = prefs.getString('user_email') ?? '';

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('donor_location').get();
      if (querySnapshot.docs.isNotEmpty) {
        List<dynamic> receiverId = [];
        List<Map<String, double>> receiverLocs = [];

        for (var doc in querySnapshot.docs) {
          String donorLocation = doc['donor_location'];
          receiverId.add(donorLocation);

          // Convert donorLocation to latitude and longitude
          List<Location> locations = await locationFromAddress(donorLocation);
          if (locations.isNotEmpty) {
            Location loc = locations.first;
            receiverLocs
                .add({'latitude': loc.latitude, 'longitude': loc.longitude});
          }
        }

        receiverIds = receiverId;
        receiverLocations = receiverLocs;
        setState(() {});
      } else {
        // No user found with the specified email
        print('User not found with ID:');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  // Future<void> getDonorLocation1() async {
  //   try {
  //     // Fetch all donor locations from Firestore
  //     QuerySnapshot donorSnapshot =
  //         await FirebaseFirestore.instance.collection('donor_location').get();

  //     if (donorSnapshot.docs.isNotEmpty) {
  //       List<String> receiverIds = [];
  //       List<Map<String, double>> receiverLocs = [];
  //       Set<Marker> newMarkers = {};

  //       // Get taker location from the widget
  //       List<String> extraLocations = ["${widget.takerlocation}"];
  //       Location takerLocation =
  //           (await locationFromAddress(widget.takerlocation)).first;

  //       // Iterate over each donor document
  //       for (var doc in donorSnapshot.docs) {
  //         String donorLocation = doc['donor_location'];

  //         // Convert donorLocation to latitude and longitude
  //         List<Location> locations = await locationFromAddress(donorLocation);
  //         if (locations.isNotEmpty) {
  //           Location loc = locations.first;
  //           receiverIds.add(donorLocation);
  //           receiverLocs
  //               .add({'latitude': loc.latitude, 'longitude': loc.longitude});

  //           // Add marker for donor location
  //           newMarkers.add(Marker(
  //             markerId: MarkerId(donorLocation),
  //             position: LatLng(loc.latitude, loc.longitude),
  //             infoWindow: InfoWindow(title: donorLocation),
  //           ));
  //         }
  //       }

  //       // Process the extra locations (taker location)
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
  //           final GoogleMapController controller = await _controller.future;
  //           controller.animateCamera(
  //             CameraUpdate.newLatLngZoom(
  //               LatLng(loc.latitude, loc.longitude),
  //               10.0, // Adjust zoom level as needed
  //             ),
  //           );
  //         }
  //       }

  //       // Update state with receiver information and markers
  //       setState(() {
  //         receiverIds = receiverIds;
  //         receiverLocations = receiverLocs;
  //         markers = newMarkers;
  //       });

  //       // Send notifications to nearby donors
  //       sendNotificationToNearbyDonors(takerLocation, receiverLocs);
  //     } else {
  //       print('No donors found.');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  Future<void> getDonorLocation1() async {
    try {
      // Fetch all donor locations from Firestore
      QuerySnapshot donorSnapshot =
          await FirebaseFirestore.instance.collection('donor_location').get();

      if (donorSnapshot.docs.isNotEmpty) {
        List<String> receiverIds = [];
        List<Map<String, double>> receiverLocs = [];
        Set<Marker> newMarkers = {};

        // Get taker location from the widget
        List<String> extraLocations = ["${widget.takerlocation}"];
        Location takerLocation =
            (await locationFromAddress(widget.takerlocation)).first;

        // Get the file path for saving the data
        Directory directory = await getApplicationDocumentsDirectory();
        File donorFile = File('${directory.path}/nearby_donors.txt');

        // Ensure file exists
        if (!await donorFile.exists()) {
          await donorFile.create();
        }

        // Iterate over each donor document
        for (var doc in donorSnapshot.docs) {
          String donorLocation = doc['donor_location'];
          String donorId =
              doc['user_id']; // Assuming you have donor_id or some identifier

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
            if (distanceInKm <= 5) {
              receiverIds.add(donorLocation);
              receiverLocs
                  .add({'latitude': loc.latitude, 'longitude': loc.longitude});

              // Add to nearby donors list for notification
              nearbyDonors.add(donorLocation);

              // Add donor details to the file
              await donorFile.writeAsString(
                'Donor ID: $donorId, Location: $donorLocation, Distance: ${distanceInKm.toStringAsFixed(2)} km\n',
                mode: FileMode.append,
              );
            }
          }
        }
        // if (nearbyDonors.isEmpty) {
        //   for (var doc in donorSnapshot.docs) {
        //     String donorLocation = doc['donor_location'];
        //     String donorId =
        //         doc['user_id']; // Assuming you have donor_id or some identifier

        //     // Convert donorLocation to latitude and longitude
        //     List<Location> locations = await locationFromAddress(donorLocation);
        //     if (locations.isNotEmpty) {
        //       Location loc = locations.first;

        //       // Add marker for donor location
        //       newMarkers.add(Marker(
        //         markerId: MarkerId(donorLocation),
        //         position: LatLng(loc.latitude, loc.longitude),
        //         infoWindow: InfoWindow(title: donorLocation),
        //       ));

        //       // Calculate distance between taker location and donor location
        //       double distanceInMeters = Geolocator.distanceBetween(
        //           takerLocation.latitude,
        //           takerLocation.longitude,
        //           loc.latitude,
        //           loc.longitude);

        //       double distanceInKm = distanceInMeters / 1000;

        //       // Check if the distance is within 5 km
        //       if (distanceInKm <= 10) {
        //         receiverIds.add(donorLocation);
        //         receiverLocs.add(
        //             {'latitude': loc.latitude, 'longitude': loc.longitude});

        //         // Add to nearby donors list for notification
        //         nearbyDonors.add(donorLocation);

        //         // Add donor details to the file
        //         await donorFile.writeAsString(
        //           'Donor ID: $donorId, Location: $donorLocation, Distance: ${distanceInKm.toStringAsFixed(2)} km\n',
        //           mode: FileMode.append,
        //         );
        //       }
        //     }
        //   }
        // }
        // if (nearbyDonors.isEmpty) {
        //   for (var doc in donorSnapshot.docs) {
        //     String donorLocation = doc['donor_location'];
        //     String donorId =
        //         doc['user_id']; // Assuming you have donor_id or some identifier

        //     // Convert donorLocation to latitude and longitude
        //     List<Location> locations = await locationFromAddress(donorLocation);
        //     if (locations.isNotEmpty) {
        //       Location loc = locations.first;

        //       // Add marker for donor location
        //       newMarkers.add(Marker(
        //         markerId: MarkerId(donorLocation),
        //         position: LatLng(loc.latitude, loc.longitude),
        //         infoWindow: InfoWindow(title: donorLocation),
        //       ));

        //       // Calculate distance between taker location and donor location
        //       double distanceInMeters = Geolocator.distanceBetween(
        //           takerLocation.latitude,
        //           takerLocation.longitude,
        //           loc.latitude,
        //           loc.longitude);

        //       double distanceInKm = distanceInMeters / 1000;

        //       // Check if the distance is within 5 km
        //       if (distanceInKm <= 20) {
        //         receiverIds.add(donorLocation);
        //         receiverLocs.add(
        //             {'latitude': loc.latitude, 'longitude': loc.longitude});

        //         // Add to nearby donors list for notification
        //         nearbyDonors.add(donorLocation);

        //         // Add donor details to the file
        //         await donorFile.writeAsString(
        //           'Donor ID: $donorId, Location: $donorLocation, Distance: ${distanceInKm.toStringAsFixed(2)} km\n',
        //           mode: FileMode.append,
        //         );
        //       }
        //     }
        //   }
        // }

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
            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(
              CameraUpdate.newLatLngZoom(
                LatLng(loc.latitude, loc.longitude),
                10.0, // Adjust zoom level as needed
              ),
            );
          }
        }

        // Update state with receiver information and markers
        setState(() {
          receiverIds = receiverIds;
          receiverLocations = receiverLocs;
          markers = newMarkers;
        });

        print('Nearby donors saved to file.');
      } else {
        print('No donors found.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getDonorLocation10KM() async {
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
        List<String> extraLocations = ["${widget.takerlocation}"];
        Location takerLocation =
            (await locationFromAddress(widget.takerlocation)).first;

        // Get the file path for saving the data
        Directory directory = await getApplicationDocumentsDirectory();
        File donorFile = File('${directory.path}/nearby_donors.txt');

        // Ensure file exists
        if (!await donorFile.exists()) {
          await donorFile.create();
        }

        // Iterate over each donor document
        for (var doc in donorSnapshot.docs) {
          String donorLocation = doc['donor_location'];
          String donorId =
              doc['user_id']; // Assuming you have donor_id or some identifier

          // Convert donorLocation to latitude and longitude
          List<Location> locations = await locationFromAddress(donorLocation);
          if (locations.isNotEmpty) {
            Location loc = locations.first;

            // Add marker for donor location
            // newMarkers.add(Marker(
            //   markerId: MarkerId(donorLocation),
            //   position: LatLng(loc.latitude, loc.longitude),
            //   infoWindow: InfoWindow(title: donorLocation),
            // ));

            // Calculate distance between taker location and donor location
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

              // Add donor details to the file
              await donorFile.writeAsString(
                'Donor ID: $donorId, Location: $donorLocation, Distance: ${distanceInKm.toStringAsFixed(2)} km\n',
                mode: FileMode.append,
              );
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
            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(
              CameraUpdate.newLatLngZoom(
                LatLng(loc.latitude, loc.longitude),
                10.0, // Adjust zoom level as needed
              ),
            );
          }
        }

        // Update state with receiver information and markers
        setState(() {
          receiverIds = receiverIds;
          receiverLocations = receiverLocs;
          markers = newMarkers;
        });

        print('Nearby donors saved to file.');
        await sendNotificationsToNearbyDonors(nearbyDonors);
      } else {
        print('No donors found.');
      }
    } catch (e) {
      print('Error: $e');
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
        List<String> extraLocations = ["${widget.takerlocation}"];
        Location takerLocation =
            (await locationFromAddress(widget.takerlocation)).first;

        // Get the file path for saving the data
        Directory directory = await getApplicationDocumentsDirectory();
        File donorFile = File('${directory.path}/nearby_donors.txt');

        // Ensure file exists
        if (!await donorFile.exists()) {
          await donorFile.create();
        }

        // Iterate over each donor document
        for (var doc in donorSnapshot.docs) {
          String donorLocation = doc['donor_location'];
          String donorId =
              doc['user_id']; // Assuming you have donor_id or some identifier

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

              // Add donor details to the file
              await donorFile.writeAsString(
                'Donor ID: $donorId, Location: $donorLocation, Distance: ${distanceInKm.toStringAsFixed(2)} km\n',
                mode: FileMode.append,
              );
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
            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(
              CameraUpdate.newLatLngZoom(
                LatLng(loc.latitude, loc.longitude),
                10.0, // Adjust zoom level as needed
              ),
            );
          }
        }

        // Update state with receiver information and markers
        setState(() {
          receiverIds = receiverIds;
          receiverLocations = receiverLocs;
          markers = newMarkers;
        });

        print('Nearby donors saved to file.');
        await sendNotificationsToNearbyDonors1(nearbyDonors);
      } else {
        print('No donors found.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getDonorLocation20KM() async {
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
        List<String> extraLocations = ["${widget.takerlocation}"];
        Location takerLocation =
            (await locationFromAddress(widget.takerlocation)).first;

        // Get the file path for saving the data
        Directory directory = await getApplicationDocumentsDirectory();
        File donorFile = File('${directory.path}/nearby_donors.txt');

        // Ensure file exists
        if (!await donorFile.exists()) {
          await donorFile.create();
        }

        // Iterate over each donor document
        for (var doc in donorSnapshot.docs) {
          String donorLocation = doc['donor_location'];
          String donorId =
              doc['user_id']; // Assuming you have donor_id or some identifier

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
              await donorFile.writeAsString(
                'Donor ID: $donorId, Location: $donorLocation, Distance: ${distanceInKm.toStringAsFixed(2)} km\n',
                mode: FileMode.append,
              );
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
            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(
              CameraUpdate.newLatLngZoom(
                LatLng(loc.latitude, loc.longitude),
                10.0, // Adjust zoom level as needed
              ),
            );
          }
        }

        // Update state with receiver information and markers
        setState(() {
          receiverIds = receiverIds;
          receiverLocations = receiverLocs;
          markers = newMarkers;
        });

        print('Nearby donors saved to file.');
        await sendNotificationsToNearbyDonors1(nearbyDonors);
      } else {
        print('No donors found.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  // Future<void> sendNotificationWithin5KM() async {
  //   try {
  //         List<String> receiverIds = [];
  //       List<Map<String, double>> receiverLocs = [];
  //       Set<Marker> newMarkers = {};
  //     QuerySnapshot donorSnapshot =
  //         await FirebaseFirestore.instance.collection('donor_location').get();
  //     for (var doc in donorSnapshot.docs) {
  //       String donorLocation = doc['donor_location'];
  //       String donorId =
  //           doc['user_id']; // Assuming you have donor_id or some identifier

  //       // Convert donorLocation to latitude and longitude
  //       List<Location> locations = await locationFromAddress(donorLocation);
  //       if (locations.isNotEmpty) {
  //         Location loc = locations.first;

  //         // Add marker for donor location
  //         newMarkers.add(Marker(
  //           markerId: MarkerId(donorLocation),
  //           position: LatLng(loc.latitude, loc.longitude),
  //           infoWindow: InfoWindow(title: donorLocation),
  //         ));

  //         // Calculate distance between taker location and donor location
  //         double distanceInMeters = Geolocator.distanceBetween(
  //             takerLocation.latitude,
  //             takerLocation.longitude,
  //             loc.latitude,
  //             loc.longitude);

  //         double distanceInKm = distanceInMeters / 1000;

  //         // Check if the distance is within 5 km
  //         if (distanceInKm <= 10) {
  //           receiverIds.add(donorLocation);
  //           receiverLocs
  //               .add({'latitude': loc.latitude, 'longitude': loc.longitude});

  //           // Add to nearby donors list for notification
  //           nearbyDonors.add(donorLocation);

  //           // Add donor details to the file
  //           await donorFile.writeAsString(
  //             'Donor ID: $donorId, Location: $donorLocation, Distance: ${distanceInKm.toStringAsFixed(2)} km\n',
  //             mode: FileMode.append,
  //           );
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  // Future<void> getDonorLocation1() async {
  //   try {
  //     // Fetch all donor locations from Firestore
  //     QuerySnapshot donorSnapshot =
  //         await FirebaseFirestore.instance.collection('donor_location').get();

  //     if (donorSnapshot.docs.isNotEmpty) {
  //       List<String> receiverIds = [];
  //       List<Map<String, double>> receiverLocs = [];
  //       Set<Marker> newMarkers = {};

  //       // Get taker location from the widget
  //       List<String> extraLocations = ["${widget.takerlocation}"];
  //       Location takerLocation =
  //           (await locationFromAddress(widget.takerlocation)).first;

  //       // Iterate over each donor document
  //       for (var doc in donorSnapshot.docs) {
  //         String donorLocation = doc['donor_location'];

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
  //           }
  //         }
  //       }

  //       // Process the extra locations (taker location)
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
  //           final GoogleMapController controller = await _controller.future;
  //           controller.animateCamera(
  //             CameraUpdate.newLatLngZoom(
  //               LatLng(loc.latitude, loc.longitude),
  //               10.0, // Adjust zoom level as needed
  //             ),
  //           );
  //         }
  //       }

  //       // Update state with receiver information and markers
  //       setState(() {
  //         receiverIds = receiverIds;
  //         receiverLocations = receiverLocs;
  //         markers = newMarkers;
  //       });

  //       // Send notifications to nearby donors
  //       // Implement this function as needed
  //     } else {
  //       print('No donors found.');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

// Implement the notification function
  void notifyNearbyDonors(List<String> nearbyDonors) {
    for (String donor in nearbyDonors) {
      // Implement your notification logic here
      print('Notifying donor at $donor');
    }
  }

  Future<void> sendNotificationsToNearbyDonors(
      List<String> nearbyLocations) async {
    try {
      showLoader("Please Wait!");
      if (nearbyLocations.isEmpty) {
        EasyLoading.dismiss();
        // Show CupertinoActionSheet if nearbyLocations is empty
        await showCupertinoModalPopup<void>(
          context: context,
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

            log("List is $userId");
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
            if (widget.blood == bloodType) {
              var data = {
                'message': {
                  'token': deviceToken,
                  'notification': {
                    'title': 'New Blood Request',
                    'body':
                        'You have a new blood request from ${widget.fullname} for blood ${widget.blood}.'
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
                print('Notification sent successfully to user: ${userDoc.id}');
              } else {
                print(
                    'Failed to send notification to user: ${userDoc.id}. Status code: ${response.statusCode}');
                print('Response body: ${response.body}');
                EasyLoading.dismiss();
              }
            }
          }
        }
        _addRequest();
      }
    } catch (e) {
      print('Error sending notification: $e');
      EasyLoading.dismiss();
    }
  }

  Future<void> sendNotificationsToNearbyDonors1(
      List<String> nearbyLocations) async {
    try {
      if (nearbyLocations.isEmpty) {
        EasyLoading.dismiss();
        // Show CupertinoActionSheet if nearbyLocations is empty
        await showCupertinoModalPopup<void>(
          context: context,
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

            log("List is $userId");
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
            if (widget.blood == bloodType) {
              var data = {
                'message': {
                  'token': deviceToken,
                  'notification': {
                    'title': 'New Blood Request',
                    'body':
                        'You have a new blood request from ${widget.fullname} for blood ${widget.blood}.'
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
                print('Notification sent successfully to user: ${userDoc.id}');
              } else {
                print(
                    'Failed to send notification to user: ${userDoc.id}. Status code: ${response.statusCode}');
                print('Response body: ${response.body}');
                EasyLoading.dismiss();
              }
            }
          }
        }
        _addRequest();
      }
    } catch (e) {
      print('Error sending notification: $e');
      EasyLoading.dismiss();
    }
  }

  // void sendNotificationToNearbyDonors(
  //     Location takerLocation, List<Map<String, double>> receiverLocs) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String currentUserEmail = prefs.getString('user_email') ?? '';

  //     // Fetch all users from Firestore who are donors
  //     QuerySnapshot userSnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .where('type', isEqualTo: 'donor')
  //         .get();

  //     // Iterate over each user document
  //     for (QueryDocumentSnapshot userDoc in userSnapshot.docs) {
  //       String deviceToken = userDoc['deviceToken'];
  //       String userEmail = userDoc['email'];

  //       // Skip sending notification to the current user
  //       if (userEmail == currentUserEmail) {
  //         print('Skipping sending notification to user with email: $userEmail');
  //         continue;
  //       }

  //       // Check if the donor is within 5 km of the taker location
  //       bool isWithinRadius = false;
  //       for (var loc in receiverLocs) {
  //         double distance = Geolocator.distanceBetween(
  //           takerLocation.latitude,
  //           takerLocation.longitude,
  //           loc['latitude']!,
  //           loc['longitude']!,
  //         );

  //         if (distance <= 5000) {
  //           isWithinRadius = true;
  //           break;
  //         }
  //       }

  //       if (isWithinRadius) {
  //         // Prepare notification data
  //         var data = {
  //           'to': deviceToken,
  //           'priority': 'high',
  //           'notification': {
  //             'title': 'New Blood Request',
  //             'body':
  //                 'You have a new blood request from ${widget.fullname} for blood ${widget.blood}.'
  //           },
  //           'data': {'type': 'request_notification', 'id': 'Nomi12345'}
  //         };

  //         // Send notification to the device
  //         var response = await http.post(
  //           Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //           body: jsonEncode(data),
  //           headers: {
  //             'Content-Type': 'application/json; charset=UTF-8',
  //             'Authorization':
  //                 'key=AAAAhM4yLBU:APA91bFYi77T3adopH4ZKF6BwWAMjq0v-zrcByWIs_SukIolxTfIEXBwJLOzxF5GaYiT3xn03Y3gbQ-XWzkESGKMR1awLL3JPoc2x5dHh0uxmi-HSZ8xAHIEcQ0fF6XJ5j6KiYsyDzvU'
  //           },
  //         );

  //         // Check response status
  //         if (response.statusCode == 200) {
  //           print('Notification sent successfully to user: ${userDoc.id}');
  //         } else {
  //           print(
  //               'Failed to send notification to user: ${userDoc.id}. Status code: ${response.statusCode}');
  //           print('Response body: ${response.body}');
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print('Error sending notification: $e');
  //   }
  // }

  void _addRequest() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      // ignore: unused_local_variable
      String profileImageUrl;

      String userimage = prefs.getString('user_image') ?? '';
      print(userimage);
      // ignore: unused_local_variable, unnecessary_null_comparison
      if (userimage != null && userimage.isNotEmpty) {
        // Assuming picture is a path from a file picker
        final file = File(userimage);
        print("File is $file");

        // Check if the file exists
        if (await file.exists()) {
          String fileName =
              DateFormat('yyyyMMdd_HHmmss').format(DateTime.now()) + '.jpg';
          final storageRef =
              FirebaseStorage.instance.ref().child('profile_images/$fileName');

          // Upload the file to Firebase Storage
          await storageRef.putFile(file);
          profileImageUrl = await storageRef.getDownloadURL();
        } else {
          // Handle case where the file doesn't exist
          print("Error: File at '${widget.picture}' doesn't exist.");
          // Show an error message to the user
        }
      } else {
        // Handle case where picture path is null or empty
        print("Error: Picture path is null or empty.");
        // Show an error message to the user
      }

      // Save user data in the 'taker' collection
      DocumentReference docRef = await _firestore.collection('taker').add({
        'id': widget.takerid,
        'taker_id': '',
        'name': widget.fullname,
        'image': widget.picture,
        'email': widget.takeremail,
        'number': widget.number,
        'hospitalname': widget.hospitalname,
        'date': widget.date,
        'time': widget.time,
        'location': widget.takerlocation,
        'note': widget.note,
        'blood': widget.blood,
        'rating': widget.rating,
        'status': widget.status,
        'createdAt': FieldValue.serverTimestamp(),
      });
      String documentId = docRef.id;

      // Update the document with the document ID in place of 'takerid'
      await docRef.update({
        'taker_id': documentId,
      });
      EasyLoading.dismiss();

      _showDonatePopup();
    } catch (error) {
      EasyLoading.dismiss();
      print("Error in _handleSignup: $error");
      // Handle error and show a proper error message to the user
    }
  }

  void _showDonatePopup() {
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
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const Dashboard();
                        },
                        transitionDuration: const Duration(seconds: 1),
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
