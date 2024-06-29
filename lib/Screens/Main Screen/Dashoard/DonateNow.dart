// ignore_for_file: file_names

import 'dart:async';
import 'dart:io';

import 'package:blood_donor/Json%20Data/GoogleMapDark.dart';
import 'package:blood_donor/Screens/Main%20Screen/Dashoard/MapThroughFeed.dart';
import 'package:blood_donor/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class DonateNow extends StatefulWidget {
  final String name;
  final String image;
  final String blood;
  final String hospital;
  final String location;
  final String date;
  final String time;
  final String rating;
  final String note;
  final String id;
  final String email;
  const DonateNow(
      {super.key,
      required this.name,
      required this.image,
      required this.blood,
      required this.hospital,
      required this.location,
      required this.date,
      required this.time,
      required this.rating,
      required this.note,
      required this.id,
      required this.email});

  @override
  State<DonateNow> createState() => _DonateNowState();
}

class _DonateNowState extends State<DonateNow> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
    zoom: 10.0,
  );

  Set<Polygon> polygons = {};
  Set<Circle> circles = {};
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  bool isLightMode = false;
  String accepterrating = '';
  int accepterid = 0;
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
    getAceepterrating();
    getUserDataByEmail();
    toController.text = widget.location;
    showPath();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            // IconButton to show path
            IconButton(
              onPressed: showPath,
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
            Expanded(
              child: GoogleMap(
                mapType: isLightMode ? MapType.normal : MapType.hybrid,
                initialCameraPosition: _kGooglePlex,
                polygons: polygons,
                circles: circles,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              // ignore: sized_box_for_whitespace
              child: Container(
                height: 35.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 2.h, 70.w, 0),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: FileImage(File('${widget.image}')),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(22.w, 2.h, 0.w, 0),
                        child: Text(widget.name,
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(22.w, 5.h, 0.w, 0),
                        child: Text(widget.location,
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.black54))),
                    // Padding(
                    //     padding: EdgeInsets.fromLTRB(22.w, 7.5.h, 0.w, 0),
                    //     child: Text(donator.location,
                    //         style: TextStyle(
                    //             fontSize: 12.sp,
                    //             fontWeight: FontWeight.normal,
                    //             color: Colors.black54))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 8.h, 0.w, 0),
                        // ignore: prefer_const_constructors
                        child: Icon(
                          Icons.star,
                          size: 25,
                          color: const Color(0xFFDE0A1E),
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(30.w, 8.3.h, 0.w, 0),
                        child: Text(widget.rating,
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFDE0A1E)))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(78.w, 8.5.h, 0.w, 0),
                        child: Text(widget.blood,
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFDE0A1E)))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(2.w, 12.h, 0.w, 0),
                        child: Text('Donation Details',
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(2.w, 14.h, 0.w, 0),
                        child: Text(widget.hospital,
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.black))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(2.w, 16.h, 0.w, 0),
                        child: Text(widget.location,
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.black))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(2.w, 19.h, 0.w, 0),
                        child: Text('TIme: ${widget.time}, ${widget.date}',
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54))),

                    Padding(
                        padding: EdgeInsets.fromLTRB(2.w, 21.h, 0.w, 0),
                        child: Text(widget.note,
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54))),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 27.h, 5.w, 0),
                      child: Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showCircularProgressIndicator = true;
                            });
                            _acceptRequest();
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            // padding:
                            //     MaterialStateProperty.all<EdgeInsetsGeometry>(
                            //         // Increase horizontal padding
                            //         // ignore: prefer_const_constructors
                            //         // EdgeInsets.symmetric(
                            //         //     vertical: 2.h, horizontal: 40.w),
                            //         ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFDE0A1E)),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (showCircularProgressIndicator)
                                const SizedBox(
                                  height: 22.0, // Set your desired height here
                                  width: 22.0, // Set your desired width here
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
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
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
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
                  'images/pop.jpeg',
                  height: 20.h,
                  width: double.infinity,
                  fit: BoxFit.fill,
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
                    String name = widget.name;
                    String image = widget.image;
                    String blood1 = widget.blood;
                    String hospital = widget.hospital;
                    String location = widget.location;
                    String date = widget.date;
                    String time = widget.time;
                    String rating = widget.rating;
                    String note = widget.note;
                    String id = widget.id;
                    String em = widget.email;
                    // String donorname = name;

                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return Feed(
                              name: name,
                              image: image,
                              blood: blood1,
                              hospital: hospital,
                              location: location,
                              date: date,
                              time: time,
                              rating: rating,
                              note: note,
                              id: id,
                              email: em,
                              donorname: fullname,
                              donorimage: pic,
                              donorblood: blood,
                              donoremail: email);
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

  void _acceptRequest() async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      accepterid++;

      print(widget.location);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('takerid', isEqualTo: widget.id)
          .where('email', isEqualTo: widget.email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        await _firestore.collection('acceptdonation').add({
          'id': accepterid,
          'fullname': widget.name,
          'image': widget.image,
          'takerid': widget.id,
          'hospitalname': widget.hospital,
          'date': widget.date,
          'time': widget.time,
          'email': widget.email,
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
        _showDonatePopup();
        print('Nomi');
      } else {
        showCustomSnackBar(context, 'This taker is in donation mode', false);
        setState(() {
          showCircularProgressIndicator = false;
        });
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pop(context);
        });
      }

      // Save user data in the 'taker' collection
    } catch (error) {
      setState(() {
        showCircularProgressIndicator = false;
      });
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
}
