// ignore_for_file: avoid_print, file_names, await_only_futures

import 'dart:async';
import 'dart:convert';

import 'package:blood_donor/Json%20Data/GlobalVariable.dart';
import 'package:blood_donor/Json%20Data/GoogleMapDark.dart';
import 'package:blood_donor/Screens/Main%20Screen/Dashoard/Dashboatd.dart';
import 'package:blood_donor/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class MapOnDonator extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String id;
  final String name;
  final String image;
  final String blood;
  final String location;
  final String rating;
  final String time;
  final String date;
  final String hosname;
  final String note;
  final String email;

  // ignore: non_constant_identifier_names
  const MapOnDonator({
    Key? key,
    required this.name,
    required this.image,
    required this.blood,
    required this.location,
    required this.hosname,
    required this.rating,
    required this.time,
    required this.date,
    required this.id,
    required this.note,
    required this.email,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MapOnDonatorState createState() => _MapOnDonatorState();
}

class _MapOnDonatorState extends State<MapOnDonator> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
    zoom: 10.0,
  );

  Set<Polygon> polygons = {};
  Set<Polyline> polylines = {};
  Set<Circle> circles = {};
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  bool isLightMode = false;
  int accepterid = 0;
  String accepterrating = '';
  String email = '';
  int phone = 0;
  String fullname = '';
  String pic = '';
  String blood = '';
  bool showCircularProgressIndicator = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    getAceepterId();
    getUserDataByEmail();
    toController.text = widget.location;
    print("Location is my${widget.location}");
    getAceepterrating();

    // Call showPath function to draw the polygon on the map
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // IconButton to show path
          IconButton(
            onPressed: () {
              showPath(widget.location);
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
            height: 60.h,
            child: GoogleMap(
              mapType: isLightMode ? MapType.normal : MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              polylines: Set<Polyline>.of(polylines),
              circles: Set<Circle>.of(circles),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            // ignore: sized_box_for_whitespace
            child: Container(
              height: 25.h,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 2.h, 70.w, 0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(widget.image),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(22.w, 2.h, 0.w, 0),
                      child: Text(widget.name,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(22.w, 5.h, 0.w, 0),
                      child: Text(widget.hosname,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.black54))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(22.w, 7.5.h, 0.w, 0),
                      child: Text(widget.location,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.black54))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(70.w, 9.5.h, 0.w, 0),
                      // ignore: prefer_const_constructors
                      child: Icon(
                        Icons.star,
                        size: 25,
                        color: const Color(0xFFDE0A1E),
                      )),
                  Padding(
                      padding: EdgeInsets.fromLTRB(78.w, 9.9.h, 0.w, 0),
                      child: Text(widget.rating.toString(),
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFDE0A1E)))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(88.w, 4.h, 0.w, 0),
                      child: Text(widget.blood,
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFDE0A1E)))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(2.w, 10.h, 0.w, 0),
                      child: Text('Donation Details',
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(2.w, 12.h, 0.w, 0),
                      child: Text(widget.time,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(25.w, 12.h, 0.w, 0),
                      child: Text(widget.date,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(2.w, 14.h, 0.w, 0),
                      child: Text(widget.note,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54))),
                  Container(
                    width: 95.w,
                    height: 30.h,
                    padding: EdgeInsets.fromLTRB(3.w, 19.h, 3.w, 0),
                    // margin: EdgeInsets.only(top: 20.h),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showCircularProgressIndicator = true;
                        });
                        _acceptRequest();
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        // padding:
                        //     MaterialStateProperty.all<EdgeInsetsGeometry>(
                        //   // Increase horizontal padding
                        //   // ignore: prefer_const_constructors
                        //   EdgeInsets.symmetric(
                        //       vertical: 2.h, horizontal: 32.w),
                        // ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFDE0A1E)),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (showCircularProgressIndicator)
                            SizedBox(
                              height: 20.0, // Set your desired height here
                              width: 20.0, // Set your desired width here
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          if (!showCircularProgressIndicator)
                            Text(
                              'Donate Now',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
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
      await showPath(widget.location);
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _goToCurrentLocation() async {
    _getCurrentLocation();
  }

  Future<void> showPath(String location) async {
    try {
      String from = fromController.text;
      String to = location;

      // Fetch locations for 'from' and 'to'
      List<Location> fromLocations = await locationFromAddress(from);
      List<Location> toLocations = await locationFromAddress(to);

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
            var points = data['routes'][0]['overview_polyline']['points'];
            List<LatLng> polylineCoordinates = _decodePolyline(points);

            print('Decoded Polyline Points: $polylineCoordinates');

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

            double distanceInKm = distance / 1000;

            // Show distance in Snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Distance: ${distanceInKm.toStringAsFixed(2)} km'),
              ),
            );
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

  // ignore: unused_element
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
                  'images/image2.jpeg',
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
                    donator.name = widget.name;
                    donator.date = widget.date;
                    donator.time = widget.time;
                    donator.location = widget.location;
                    donator.blood = widget.blood;
                    donator.rating = widget.rating.toString();
                    donator.image = widget.image;
                    donator.hosname = widget.hosname;

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

  Future<void> getAceepterId() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .orderBy('id', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        int userId = userDoc['id'];
        accepterid = userId;

        print('Taker ID: $accepterid');
      } else {
        print('No documents found in the accept donation collection');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  Future<void> getAceepterrating() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .orderBy('id', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        String userId = userDoc['acceptrating'];
        accepterrating = userId;

        print('Accept Rating: $accepterrating');
      } else {
        print('No documents found in the accept donation collection');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  void _acceptRequest() async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      accepterid++;

      print(widget.location);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('takerid', isEqualTo: widget.id)
          .get();

      if (querySnapshot.docs.isEmpty) {
// Save user data in the 'taker' collection
        await _firestore.collection('acceptdonation').add({
          'id': accepterid,
          'takerid': widget.id,
          'fullname': widget.name,
          'image': widget.image,
          'email': widget.email,
          'hospitalname': widget.hosname,
          'date': widget.date,
          'time': widget.time,
          'location': widget.location,
          'note': widget.note,
          'blood': widget.blood,
          'rating': widget.rating,
          'acceptname': fullname,
          'acceptemail': email,
          'acceptnumber': phone,
          'acceptimage': pic,
          'date1': widget.date,
          'time1': widget.time,
          'acceptrating': accepterrating,
          'acceptblood': blood,
          "status": false
        });
        print('Nomi');

        _showDonatePopup();
      } else {
        showCustomSnackBar(context, 'This taker is in donation mood', false);
        setState(() {
          showCircularProgressIndicator = false;
        });
        await Future.delayed(Duration(seconds: 3));
        Navigator.pop(context);
      }
    } catch (error) {
      setState(() {
        showCircularProgressIndicator = false;
      });
      _showAlertDialog1(context);
      print("Error in _handleSignup: $error");
      // Handle error and show a proper error message to the user
    }
  }

  Future<void> getUserDataByEmail() async {
    try {
      // Use the 'where' method to query documents with the specified email
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user_email') ?? '';
      print(userEmail);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Access user data

        String email1 = userDoc['email'];
        String number = userDoc['phonenumber'];
        String name = userDoc['firstname'];
        String name1 = userDoc['lastname'];
        String image = userDoc['image'];
        String bloo = userDoc['bloodgroup'];
        email = email1;
        phone = int.parse(number);
        fullname = name + ' $name1';
        pic = image;
        blood = bloo;
        print('Nomi');
      } else {
        // No user found with the specified email
        print('User not found with email: $userEmail');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  void _showAlertDialog1(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Invalid Data'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the alert dialog
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

// import 'dart:async';

// import 'package:blood_donor/Json%20Data/GoogleMapDark.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sizer/sizer.dart';

// class MapOnDonator extends StatefulWidget {
//   final String id;
//   final String name;
//   final String image;
//   final String blood;
//   final String location;
//   final String rating;
//   final String time;
//   final String date;
//   final String hosname;
//   final String note;
//   final String email;

//   const MapOnDonator({
//     Key? key,
//     required this.name,
//     required this.image,
//     required this.blood,
//     required this.location,
//     required this.hosname,
//     required this.rating,
//     required this.time,
//     required this.date,
//     required this.id,
//     required this.note,
//     required this.email,
//   }) : super(key: key);

//   @override
//   _MapOnDonatorState createState() => _MapOnDonatorState();
// }

// class _MapOnDonatorState extends State<MapOnDonator> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(0, 0),
//     zoom: 10.0,
//   );

//   Set<Polygon> polygons = {};
//   Set<Circle> circles = {};
//   Set<Marker> markers = {};
//   Set<Polyline> polylines = {};
//   TextEditingController fromController = TextEditingController();
//   TextEditingController toController = TextEditingController();
//   bool isLightMode = false;
//   int accepterid = 0;
//   String accepterrating = '';
//   String email = '';
//   int phone = 0;
//   String fullname = '';
//   String pic = '';
//   String blood = '';
//   bool showCircularProgressIndicator = false;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//     getAceepterId();
//     getUserDataByEmail();
//     toController.text = widget.location;
//     print("Location is my${widget.location}");
//     getAceepterrating();
//     showPath(widget.location);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             onPressed: () {
//               showPath(widget.location);
//             },
//             icon: const Icon(Icons.directions),
//           ),
//           IconButton(
//             onPressed: _goToCurrentLocation,
//             icon: const Icon(
//               Icons.my_location,
//               size: 35,
//               color: Colors.black54,
//             ),
//           ),
//           Switch(
//             value: isLightMode,
//             onChanged: (value) {
//               setState(() {
//                 isLightMode = value;
//               });
//               _toggleMapMode();
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Container(
//             height: 60.h,
//             child: GoogleMap(
//               mapType: isLightMode ? MapType.normal : MapType.hybrid,
//               initialCameraPosition: _kGooglePlex,
//               polygons: polygons,
//               circles: circles,
//               markers: markers,
//               polylines: polylines,
//               onMapCreated: (GoogleMapController controller) {
//                 _controller.complete(controller);
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//             child: Container(
//               height: 25.h,
//               child: Stack(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(0, 2.h, 70.w, 0),
//                     child: CircleAvatar(
//                       radius: 30,
//                       backgroundImage: NetworkImage(widget.image),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(22.w, 2.h, 0.w, 0),
//                     child: Text(widget.name,
//                         style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black)),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(22.w, 5.h, 0.w, 0),
//                     child: Text(widget.hosname,
//                         style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.normal,
//                             color: Colors.black54)),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(22.w, 7.5.h, 0.w, 0),
//                     child: Text(widget.location,
//                         style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.normal,
//                             color: Colors.black54)),
//                   ),
//                   Padding(
//                       padding: EdgeInsets.fromLTRB(70.w, 9.5.h, 0.w, 0),
//                       child: Icon(
//                         Icons.star,
//                         size: 25,
//                         color: const Color(0xFFDE0A1E),
//                       )),
//                   Padding(
//                       padding: EdgeInsets.fromLTRB(78.w, 9.9.h, 0.w, 0),
//                       child: Text(widget.rating.toString(),
//                           style: TextStyle(
//                               fontSize: 12.sp,
//                               fontWeight: FontWeight.bold,
//                               color: const Color(0xFFDE0A1E)))),
//                   Padding(
//                       padding: EdgeInsets.fromLTRB(88.w, 4.h, 0.w, 0),
//                       child: Text(widget.blood,
//                           style: TextStyle(
//                               fontSize: 15.sp,
//                               fontWeight: FontWeight.bold,
//                               color: const Color(0xFFDE0A1E)))),
//                   Padding(
//                       padding: EdgeInsets.fromLTRB(2.w, 10.h, 0.w, 0),
//                       child: Text('Donation Details',
//                           style: TextStyle(
//                               fontSize: 12.sp,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black))),
//                   Padding(
//                       padding: EdgeInsets.fromLTRB(2.w, 12.h, 0.w, 0),
//                       child: Text(widget.time,
//                           style: TextStyle(
//                               fontSize: 12.sp,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black54))),
//                   Padding(
//                       padding: EdgeInsets.fromLTRB(25.w, 12.h, 0.w, 0),
//                       child: Text(widget.date,
//                           style: TextStyle(
//                               fontSize: 12.sp,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black54))),
//                   Padding(
//                       padding: EdgeInsets.fromLTRB(2.w, 14.h, 0.w, 0),
//                       child: Text(widget.note,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                               fontSize: 12.sp,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black54))),
//                   Container(
//                     width: 95.w,
//                     height: 30.h,
//                     padding: EdgeInsets.fromLTRB(3.w, 19.h, 3.w, 0),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           showCircularProgressIndicator = true;
//                         });
//                         _acceptRequest();
//                       },
//                       style: ButtonStyle(
//                         shape:
//                             MaterialStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                         ),
//                         backgroundColor: MaterialStateProperty.all<Color>(
//                             const Color(0xFFDE0A1E)),
//                       ),
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           if (showCircularProgressIndicator)
//                             SizedBox(
//                               height: 20.0,
//                               width: 20.0,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2.0,
//                                 valueColor:
//                                     AlwaysStoppedAnimation<Color>(Colors.white),
//                               ),
//                             ),
//                           if (!showCircularProgressIndicator)
//                             Text(
//                               'Donate Now',
//                               style: TextStyle(
//                                 fontSize: 12.sp,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       final GoogleMapController controller = await _controller.future;

//       setState(() {
//         circles.clear();
//         circles.add(Circle(
//           circleId: const CircleId('CurrentLocationCircle'),
//           center: LatLng(position.latitude, position.longitude),
//           radius: 120.0,
//           fillColor: Colors.blue.withOpacity(0.3),
//           strokeColor: Colors.blue,
//           strokeWidth: 10,
//         ));

//         _addMarker(position.latitude, position.longitude, "images/image4.jpeg");

//         controller.animateCamera(
//           CameraUpdate.newLatLngZoom(
//             LatLng(position.latitude, position.longitude),
//             9.6,
//           ),
//         );

//         fromController.text =
//             "${position.latitude.toString()}, ${position.longitude.toString()}";
//       });
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   Future<void> _goToCurrentLocation() async {
//     _getCurrentLocation();
//   }

//   Future<void> showPath(String location) async {
//     try {
//       String from = fromController.text;
//       String to = location;

//       List<Location> fromLocations = await locationFromAddress(from);
//       List<Location> toLocations = await locationFromAddress(to);

//       if (fromLocations.isNotEmpty && toLocations.isNotEmpty) {
//         Location fromLocation = fromLocations.first;

//         Location? toLocation = await _chooseLocation(toLocations);

//         if (toLocation != null) {
//           final GoogleMapController controller = await _controller.future;

//           LatLng fromLatLng =
//               LatLng(fromLocation.latitude, fromLocation.longitude);
//           LatLng toLatLng = LatLng(toLocation.latitude, toLocation.longitude);

//           _addMarker(
//               fromLatLng.latitude, fromLatLng.longitude, "images/image4.jpeg");
//           _addMarker(
//               toLatLng.latitude, toLatLng.longitude, "images/image4.jpeg");

//           setState(() {
//             circles.clear();
//             circles.add(Circle(
//               circleId: const CircleId('CurrentLocationCircle'),
//               center: fromLatLng,
//               radius: 120.0,
//               fillColor: Colors.blue.withOpacity(0.3),
//               strokeColor: Colors.blue,
//               strokeWidth: 10,
//             ));
//             circles.add(Circle(
//               circleId: const CircleId('DestinationCircle'),
//               center: toLatLng,
//               radius: 120.0,
//               fillColor: Colors.green.withOpacity(0.3),
//               strokeColor: Colors.green,
//               strokeWidth: 10,
//             ));
//             polygons.clear();
//             polygons.add(Polygon(
//               polygonId: const PolygonId('PathPolygon'),
//               points: [fromLatLng, toLatLng],
//               fillColor: const Color(0xFFDE0A1E).withOpacity(0.5),
//               strokeWidth: 2,
//               strokeColor: const Color(0xFFDE0A1E),
//             ));
//           });

//           double distance = await Geolocator.distanceBetween(
//             fromLocation.latitude,
//             fromLocation.longitude,
//             toLocation.latitude,
//             toLocation.longitude,
//           );

//           double distanceInKm = distance / 1000;

//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Distance: ${distanceInKm.toStringAsFixed(2)} km'),
//             ),
//           );
//           setState(() {});
//         }
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   Future<Location?> _chooseLocation(List<Location> locations) async {
//     return locations.first;
//   }

//   void _addMarker(double lat, double lng, String assetPath) async {
//     final BitmapDescriptor markerBitmap = await BitmapDescriptor.fromAssetImage(
//       ImageConfiguration(size: Size(5, 5)),
//       assetPath,
//     );

//     setState(() {
//       markers.add(Marker(
//         markerId: MarkerId(assetPath),
//         position: LatLng(lat, lng),
//         icon: markerBitmap,
//       ));
//     });
//   }

//   Future<void> _toggleMapMode() async {
//     final GoogleMapController controller = await _controller.future;
//     controller.setMapStyle(isLightMode ? null : darkMapStyle);
//   }

//   void _showDonatePopup() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           contentPadding: const EdgeInsets.all(16.0),
//           backgroundColor: Colors.white,
//           title: Center(
//             child: Column(
//               children: [
//                 Image.asset(
//                   'images/image2.jpeg',
//                   height: 40.h,
//                   width: 40.w,
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   'Donate',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           content: const Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Thanks for accepting the request.\nNow check Donation details in blood journey map',
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//           actions: [
//             Padding(
//               padding: EdgeInsets.fromLTRB(15.w, 5.h, 15.w, 0),
//               child: Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Navigate to Dashboard or another screen
//                   },
//                   style: ElevatedButton.styleFrom(
//                       shape: const CircleBorder(),
//                       elevation: 8,
//                       padding: EdgeInsets.all(4.0.w),
//                       backgroundColor: const Color(0xFFDE0A1E)),
//                   child: const Icon(
//                     Icons.arrow_forward,
//                     size: 32,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> getAceepterId() async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('acceptdonation')
//           .orderBy('id', descending: true)
//           .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         DocumentSnapshot userDoc = querySnapshot.docs.first;

//         int userId = userDoc['id'];
//         accepterid = userId;

//         print('Taker ID: $accepterid');
//       } else {
//         print('No documents found in the accept donation collection');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   Future<void> getAceepterrating() async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('acceptdonation')
//           .orderBy('id', descending: true)
//           .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         DocumentSnapshot userDoc = querySnapshot.docs.first;

//         String userId = userDoc['acceptrating'];
//         accepterrating = userId;

//         print('Accept Rating: $accepterrating');
//       } else {
//         print('No documents found in the accept donation collection');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   void _acceptRequest() async {
//     try {
//       final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//       accepterid++;

//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('acceptdonation')
//           .where('takerid', isEqualTo: widget.id)
//           .get();

//       if (querySnapshot.docs.isEmpty) {
//         await _firestore.collection('acceptdonation').add({
//           'id': accepterid,
//           'takerid': widget.id,
//           'fullname': widget.name,
//           'image': widget.image,
//           'email': widget.email,
//           'hospitalname': widget.hosname,
//           'date': widget.date,
//           'time': widget.time,
//           'location': widget.location,
//           'note': widget.note,
//           'blood': widget.blood,
//           'rating': widget.rating,
//           'acceptname': fullname,
//           'acceptemail': email,
//           'acceptnumber': phone,
//           'acceptimage': pic,
//           'date1': widget.date,
//           'time1': widget.time,
//           'acceptrating': accepterrating,
//           'acceptblood': blood,
//           "status": false
//         });
//         _showDonatePopup();
//       } else {
//         // Show custom snackbar or message
//         setState(() {
//           showCircularProgressIndicator = false;
//         });
//         await Future.delayed(Duration(seconds: 3));
//         Navigator.pop(context);
//       }
//     } catch (error) {
//       setState(() {
//         showCircularProgressIndicator = false;
//       });
//       _showAlertDialog1(context);
//       print("Error in _handleSignup: $error");
//     }
//   }

//   Future<void> getUserDataByEmail() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String userEmail = prefs.getString('user_email') ?? '';
//       print(userEmail);
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('email', isEqualTo: userEmail)
//           .get();
//       if (querySnapshot.docs.isNotEmpty) {
//         DocumentSnapshot userDoc = querySnapshot.docs.first;

//         String email1 = userDoc['email'];
//         String number = userDoc['phonenumber'];
//         String name = userDoc['firstname'];
//         String name1 = userDoc['lastname'];
//         String image = userDoc['image'];
//         String bloo = userDoc['bloodgroup'];
//         email = email1;
//         phone = int.parse(number);
//         fullname = name + ' $name1';
//         pic = image;
//         blood = bloo;
//         print('Nomi');
//       } else {
//         print('User not found with email: $userEmail');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   void _showAlertDialog1(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Alert'),
//           content: const Text('Invalid Data'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
