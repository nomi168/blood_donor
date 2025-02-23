import 'dart:async';
import 'dart:convert';

import 'package:blood_donor/Json%20Data/GoogleMapDark.dart';
import 'package:blood_donor/Modals/acceptance_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class TakerMoreInfo extends StatefulWidget {
  final AcceptanceModel acceptModel;
  const TakerMoreInfo({super.key, required this.acceptModel});

  @override
  State<TakerMoreInfo> createState() => _TakerMoreInfoState();
}

class _TakerMoreInfoState extends State<TakerMoreInfo> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.7749, -122.4194), // Example: San Francisco
    zoom: 10.0,
  );

  bool isLightMode = false;
  Set<Polygon> polygons = {};
  Set<Polyline> polylines = {};
  Set<Circle> circles = {};
  double shortdistance = 0.0;
  bool showCircularProgressIndicator = false;
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  double distanceInKm = 0.0;
  bool isReceived = false;

  @override
  void initState() {
    _goToCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // IconButton to show path
          IconButton(
            onPressed: () {
              // showPath(widget.location);
            },
            icon: const Icon(Icons.directions),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0.w, 0, 0, 0),
              child: IconButton(
                onPressed: _goToCurrentLocation,
                icon: const Icon(
                  Icons.my_location,
                  size: 35,
                  color: Colors.black54,
                ),
              )),
          // Switch for light/dark mode
          Switch(
            value: isLightMode,
            onChanged: (value) {
              setState(() {
                isLightMode = value;
              });
              _toggleMapMode();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 41.h,
            child: GoogleMap(
              mapType: isLightMode ? MapType.normal : MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              polylines: Set<Polyline>.of(polylines),
              circles: Set<Circle>.of(circles),
              onMapCreated: (GoogleMapController controller) {
                if (!_controller.isCompleted) {
                  _controller.complete(controller);
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
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
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
                            fontWeight: FontWeight.w500, color: Colors.black54),
                      ),
                      Spacer(),
                      Text(widget.acceptModel.blood!,
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
                            fontWeight: FontWeight.w500, color: Colors.black54),
                      ),
                      Spacer(),
                      Text(
                        widget.acceptModel.location!,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black54),
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
                            fontWeight: FontWeight.w500, color: Colors.black54),
                      ),
                      Spacer(),
                      Text(
                        widget.acceptModel.hospital!,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black54),
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
                            fontWeight: FontWeight.w500, color: Colors.black54),
                      ),
                      Spacer(),
                      Text(
                        widget.acceptModel.rating!,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black54),
                      ),
                      SizedBox(
                        width: 5,
                      )
                    ],
                  ),
                ]),
          ),
          InkWell(
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            onTap: () async {
              if (isReceived == false) {
                bool? response = await sendNotificationToDonor(
                    widget.acceptModel.acceptEmail!, hours, minutes, seconds);
                if (response) {
                  setState(() {
                    isReceived = true;
                  });
                }
              } else {
                EasyLoading.showToast(
                    'you are already notify to ${widget.acceptModel.acceptName}');
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
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          isReceived
              ? InkWell(
                  splashColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  onTap: () async {
                    await sendNotificationToDonorReached(
                        widget.acceptModel.acceptEmail!);
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
        ],
      ),
    );
  }

  Future<void> updateReceivedStatue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('user_email');
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('acceptdonation')
        .where('email', isEqualTo: email)
        .where('acceptemail', isEqualTo: widget.acceptModel.acceptEmail)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Get the document reference
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      String documentId = documentSnapshot.id;

      // Update the data in the document
      await FirebaseFirestore.instance
          .collection('acceptdonation')
          .doc(documentId)
          .update({'received_status': true});
    }
  }

  Future<bool> sendNotificationToDonor(
      String email, int hours, int minutes, int seconds) async {
    try {
      String projectId = 'blood-app-8f4c2';
      String? token = await FirebaseMessaging.instance.getToken();

      // Fetch all users from Firestore who are donors
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      // If no users found, return false
      if (querySnapshot.docs.isEmpty) {
        print("No user found with email: $email");
        return false;
      }

      // Iterate over each user document
      for (QueryDocumentSnapshot userDoc in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id) // Get the correct document ID
            .update({'deviceToken': token});
        // Get the device token and name from the user document
        String firstName = userDoc['firstname'];
        String lastName = userDoc['lastname'];
        String name = "$firstName $lastName";

        String deviceToken = userDoc['deviceToken'];

        print("Device Token: $deviceToken");

        var data = {
          'message': {
            'token': deviceToken,
            'notification': {
              'title': 'Blood Request',
              'body':
                  'Hello $name,\nI am on my way and will arrive in ${hours > 0 ? "$hours hours, " : ""}${minutes > 0 ? "$minutes minutes, " : ""}${seconds > 0 ? "$seconds seconds" : ""}.',
            },
            'data': {'type': 'request_notification', 'id': 'Nomi12345'}
          }
        };

        // Generate OAuth2 token using service account
        var jsonString = await rootBundle.loadString('images/json/key1.json');
        var clientCredentials =
            auth.ServiceAccountCredentials.fromJson(jsonString);
        var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
        var client =
            await auth.clientViaServiceAccount(clientCredentials, scopes);

        var response = await http.post(
          Uri.parse(
              'https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
          headers: {
            'Authorization': 'Bearer ${client.credentials.accessToken.data}',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data),
        );

        print("Notification Token: ${client.credentials.accessToken.data}");

        // Check response status
        if (response.statusCode == 200) {
          print('Notification sent successfully to user: $name');
          return true;
        } else {
          print(
              'Failed to send notification to user: ${userDoc.id}. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      print('Error sending notification: $e');
    }

    // Ensure function always returns a value
    return false;
  }

  Future<bool> sendNotificationToDonorReached(String email) async {
    try {
      String projectId = 'blood-app-8f4c2';
      String? token = await FirebaseMessaging.instance.getToken();

      // Fetch all users from Firestore who are donors
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      // If no users found, return false
      if (querySnapshot.docs.isEmpty) {
        print("No user found with email: $email");
        return false;
      }

      // Iterate over each user document
      for (QueryDocumentSnapshot userDoc in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id) // Get the correct document ID
            .update({'deviceToken': token});
        // Get the device token and name from the user document
        String firstName = userDoc['firstname'];
        String lastName = userDoc['lastname'];
        String name = "$firstName $lastName";

        String deviceToken = userDoc['deviceToken'];

        print("Device Token: $deviceToken");

        var data = {
          'message': {
            'token': deviceToken,
            'notification': {
              'title': 'Blood Request',
              'body': 'Hello $name,\nI am reached on your location.',
            },
            'data': {'type': 'request_notification', 'id': 'Nomi12345'}
          }
        };

        // Generate OAuth2 token using service account
        var jsonString = await rootBundle.loadString('images/json/key1.json');
        var clientCredentials =
            auth.ServiceAccountCredentials.fromJson(jsonString);
        var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
        var client =
            await auth.clientViaServiceAccount(clientCredentials, scopes);

        var response = await http.post(
          Uri.parse(
              'https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
          headers: {
            'Authorization': 'Bearer ${client.credentials.accessToken.data}',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data),
        );

        print("Notification Token: ${client.credentials.accessToken.data}");

        // Check response status
        if (response.statusCode == 200) {
          print('Notification sent successfully to user: $name');
          await updateReceivedStatue();
          return true;
        } else {
          print(
              'Failed to send notification to user: ${userDoc.id}. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      print('Error sending notification: $e');
    }

    // Ensure function always returns a value
    return false;
  }

  Widget _buildAnimatedPopup(BuildContext context, String note) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: 300,
        height: 200,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Note",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              note,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red),
                textStyle: WidgetStateProperty.all(
                  TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    // Get current location
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
        fillColor: Colors.blue.withValues(alpha: 0.3),
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

    await showPath(widget.acceptModel.location!);
  }

  Future<void> _goToCurrentLocation() async {
    await _getCurrentLocation();
  }

  Future<void> showPath(String location) async {
    try {
      String from = location;
      String? to = await getDonorCurrentLocation();

      // Fetch locations for 'from' and 'to'
      List<Location> fromLocations = await locationFromAddress(from);
      List<Location> toLocations = await locationFromAddress(to!);

      if (fromLocations.isNotEmpty && toLocations.isNotEmpty) {
        Location fromLocation = fromLocations.first;

        // Allow user to choose the correct destination from multiple results
        Location? toLocation = await _chooseLocation(toLocations);

        if (toLocation != null) {
          final GoogleMapController controller = await _controller.future;

          LatLng fromLatLng =
              LatLng(fromLocation.latitude, fromLocation.longitude);
          LatLng toLatLng = LatLng(toLocation.latitude, toLocation.longitude);

          // Fetch the directions from Google Directions API
          String url =
              "https://maps.googleapis.com/maps/api/directions/json?origin=${fromLocation.latitude},${fromLocation.longitude}&destination=${toLocation.latitude},${toLocation.longitude}&key=AIzaSyAn6fh8krl1H-wflk6gHJ2aWoFEGAuaseI";

          var response = await http.get(Uri.parse(url));
          Map<String, dynamic> data = jsonDecode(response.body);

          if (data['routes'] != null && data['routes'].isNotEmpty) {
            var route = data['routes'][0];
            var points = route['overview_polyline']['points'];
            var durationInSeconds =
                route['legs'][0]['duration']['value']; // in seconds
            String durationText =
                route['legs'][0]['duration']['text']; // Readable format

            // Convert duration into hours, minutes, and seconds
            hours = 0;
            minutes = 0;
            seconds = 0;
            hours = durationInSeconds ~/ 3600;
            minutes = (durationInSeconds % 3600) ~/ 60;
            seconds = durationInSeconds % 60;

            print('Duration: $durationText');
            print(
                'Calculated Duration: $hours hours, $minutes minutes, $seconds seconds');

            List<LatLng> polylineCoordinates = _decodePolyline(points);

            setState(() {
              // Clear previous polylines and circles
              polylines.clear();
              circles.clear();

              // Add polyline following the road
              polylines.add(Polyline(
                polylineId: const PolylineId('Path'),
                color: Colors.blue.shade500,
                width: 5,
                points: polylineCoordinates,
              ));

              // Add circles for the start and end points
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
            });

            // Animate the camera to fit both points
            LatLngBounds bounds = LatLngBounds(
              southwest: LatLng(
                fromLocation.latitude < toLocation.latitude
                    ? fromLocation.latitude
                    : toLocation.latitude,
                fromLocation.longitude < toLocation.longitude
                    ? fromLocation.longitude
                    : toLocation.longitude,
              ),
              northeast: LatLng(
                fromLocation.latitude > toLocation.latitude
                    ? fromLocation.latitude
                    : toLocation.latitude,
                fromLocation.longitude > toLocation.longitude
                    ? fromLocation.longitude
                    : toLocation.longitude,
              ),
            );
            controller
                .animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));

            double distance = await Geolocator.distanceBetween(
              fromLocation.latitude,
              fromLocation.longitude,
              toLocation.latitude,
              toLocation.longitude,
            );
            distanceInKm = 0.0;

            distanceInKm = distance / 1000;

            // Show distance and travel time in Snackbar
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(
            //         'Distance: ${distanceInKm.toStringAsFixed(2)} km\nTime: ${hours}h ${minutes}m ${seconds}s'),
            //   ),
            // );
          } else {
            print('No route found');
          }
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> polylineCoordinates = [];
    int index = 0;
    int len = polyline.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int shift = 0;
      int result = 0;
      int b;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng point = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      polylineCoordinates.add(point);
    }
    return polylineCoordinates;
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

  Future<String?> getDonorCurrentLocation() async {
    try {
      // Step 1: Fetch user document ID based on email
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.acceptModel.acceptEmail)
          .limit(1) // Optimize performance by limiting to one result
          .get();

      if (userSnapshot.docs.isEmpty) {
        print('User not found');
        return null; // Returning null instead of empty string
      }

      String userId = userSnapshot.docs.first.id;

      // Step 2: Use the user ID to fetch the donor's location
      QuerySnapshot locationSnapshot = await FirebaseFirestore.instance
          .collection('donor_location')
          .where('user_id', isEqualTo: userId)
          .limit(1) // Optimize query performance
          .get();

      if (locationSnapshot.docs.isNotEmpty) {
        return locationSnapshot.docs.first['donor_location'] as String?;
      }

      print('Location not found');
      return null;
    } catch (e) {
      print('Error fetching location: $e');
      return null;
    }
  }
}
