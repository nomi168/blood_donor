// ignore_for_file: file_names

import 'dart:async';
import 'dart:io';

import 'package:blood_donor/Json%20Data/GoogleMapDark.dart';
import 'package:blood_donor/Screens/Main%20Screen/Dashoard/Review1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

class Feed1 extends StatefulWidget {
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
  final String donorname;
  final String donoremail;
  final String donorimage;
  final String donorblood;
  final String takerid;

  const Feed1({
    super.key,
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
    required this.email,
    required this.donorname,
    required this.donorimage,
    required this.donorblood,
    required this.donoremail,
    required this.takerid,
  });

  @override
  State<Feed1> createState() => _Feed1State();
}

class _Feed1State extends State<Feed1> {
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
  TextEditingController review = TextEditingController();
  bool isLightMode = false;
  int selectedRating = -1;
  String rat = '';
  double rati = 0.0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    toController.text = widget.location;
    getTakerRating();
    showPath();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, oreintation, deviceType) {
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
          backgroundColor: Colors.white,
          body: Stack(children: [
            Container(
              color: const Color.fromRGBO(244, 67, 54, 1),
              height: 35.h,
              width: 100.w,
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
              padding: EdgeInsets.fromLTRB(5.w, 30.h, 5.w, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                height: 11.h,
                width: 100.w,
                child: Stack(
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(7.w, 1.5.h, 0, 3.h),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundImage: FileImage(File('${widget.image}')),
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(27.w, 1.h, 0, 3.h),
                        child: Text(
                          widget.name,
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(27.w, 4.h, 0, 3.h),
                        child: Text(
                          widget.hospital,
                          style:
                              TextStyle(fontSize: 11.sp, color: Colors.black),
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(27.w, 6.5.h, 0, 3.h),
                        child: const Icon(Icons.star,
                            size: 20, color: Color(0xFFDE0A1E))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(34.w, 6.5.h, 0, 0.h),
                        child: Text(
                          widget.rating,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFDE0A1E)),
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(75.w, 0.h, 0, 3.h),
                        child: IconButton(
                          icon: const Icon(
                            Icons.messenger_sharp,
                            size: 22,
                            color: Color(0xFFDE0A1E),
                          ),
                          onPressed: () {},
                        )),
                  ],
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(5.w, 42.h, 0, 0.h),
                child: Text(
                  'Donation Details',
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(5.w, 46.h, 0, 0.h),
                child: Text(
                  'Location-',
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(23.w, 46.h, 0, 0.h),
                child: Text(
                  widget.location,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(5.w, 50.h, 0, 0.h),
                child: Text(
                  'Schedule-',
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(25.w, 50.h, 0, 0.h),
                child: Text(
                  widget.date,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(47.w, 50.h, 0, 0.h),
                child: Text(
                  ', ${widget.time}',
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(5.w, 57.h, 0, 0.h),
                child: Text(
                  'Share Your Feedback',
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 0.h, 0, 0.h),
              child: Row(
                children: [
                  buildStar(1),
                  buildStar(2),
                  buildStar(3),
                  buildStar(4),
                  buildStar(5),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 65.h, 5.w, 0),
              child: Material(
                elevation: 7.0,
                borderRadius: BorderRadius.circular(10.0),
                child: TextField(
                  controller: review,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 30.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    hintText:
                        'Tell us how was your expericence wuth the seeker',
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(5.w, 78.h, 5.w, 2.h),
                child: SizedBox(
                  height: 8.h,
                  width: 100.w,
                  child: Material(
                      borderRadius:
                          BorderRadius.circular(10.0), // Add border radius
                      elevation: 5.0,
                      color: const Color(0xFFDE0A1E),
                      child: Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.fromLTRB(5.w, 0, 0, 0),
                              child: TextButton(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70),
                                ),
                                onPressed: () {
                                  add();
                                },
                              )),
                          Padding(
                            padding: EdgeInsets.fromLTRB(17.w, 0, 0, 0),
                            child: const VerticalDivider(
                              color: Colors.white, // Adjust the color as needed
                              thickness: 2.0, // Adjust the thickness as needed
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
                              child: TextButton(
                                child: Text(
                                  'Donated',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                onPressed: () {
                                  _showConfirmationDialog(context);
                                },
                              ))
                        ],
                      )),
                ))
          ]),
        );
      },
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

  Widget buildStar(int starNumber) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.h, 60.h, 0, 0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedRating = starNumber;
          });
        },
        child: Icon(
          Icons.star,
          size: 23,
          color: starNumber <= selectedRating
              ? const Color.fromARGB(255, 224, 208, 63)
              : Colors.black54,
        ),
      ),
    );
  }

// Method to get the rating out of 5
  double getRatingOutOf5() {
    if (selectedRating == -1) {
      // No stars selected yet
      return 0.0;
    } else {
      // Convert selectedRating to a rating out of 5
      return selectedRating / 5.0;
    }
  }

  void add() {
    double ratingOutOf5 = getRatingOutOf5();
    rat = ratingOutOf5.toString();
    print("Rating is $rat");
  }

  Future<void> getTakerRating() async {
    try {
      String userid = widget.id;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('taker')
          .where('id', isEqualTo: userid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        String userId = userDoc['rating'];
        double rae = double.parse(userId);
        rati = rae;

        print('Taker Ratinf is here: $rati');
      } else {
        print('No documents found in the Request collection');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  Future<void> updateAcceptDonationData() async {
    try {
      double r = double.parse(rat);
      double ree = (r + rati) / 2;
      String rrr = ree.toString();

      // Query Firestore to get the document that matches the user's email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('taker')
          .where('id', isEqualTo: widget.id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document reference
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String documentId = documentSnapshot.id;

        // Update the data in the document
        await FirebaseFirestore.instance
            .collection('taker')
            .doc(documentId)
            .update({
          'rating': rrr,
          'review': review.text,
        });
        // Navigator.pushReplacement(
        //   context,
        //   PageRouteBuilder(
        //     pageBuilder: (context, animation, secondaryAnimation) {
        //       return const Dashboard();
        //     },
        //     transitionDuration: const Duration(seconds: 1),
        //     transitionsBuilder:
        //         (context, animation, secondaryAnimation, child) {
        //       const begin = Offset(10.0, 0.0); // slide in from the right
        //       const end = Offset.zero;
        //       const curve = Curves.easeInOutQuart;

        //       var tween =
        //           Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        //       var offsetAnimation = animation.drive(tween);

        //       return SlideTransition(
        //         position: offsetAnimation,
        //         child: child,
        //       );
        //     },
        //   ),
        // );

        print('Data updated successfully in acceptdonation table');
      } else {
        print('User not found with email:');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // ignore: unused_element
  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            'You have Successfully donated blood to the seeker',
          ),
          actions: <Widget>[
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0.w, 0.h, 3.w, 0),
                  child: Material(
                    elevation: 10.0,
                    shadowColor: Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        String name = widget.name;
                        String image = widget.image;
                        String blood = widget.blood;
                        String hospital = widget.hospital;
                        String location = widget.location;
                        String date = widget.date;
                        String time = widget.time;
                        String rating = widget.rating;
                        String note = widget.note;
                        String review1 = review.text;
                        String id = widget.id;
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return Review1(
                                  name: name,
                                  image: image,
                                  blood: blood,
                                  hospital: hospital,
                                  location: location,
                                  date: date,
                                  time: time,
                                  rating: rating,
                                  note: note,
                                  review: review1,
                                  email: widget.email,
                                  donorname: widget.donorname,
                                  donoremail: widget.donoremail,
                                  donorblood: widget.donorblood,
                                  donorimage: widget.donorimage,
                                  id: id,
                                  takerid: widget.takerid);
                            },
                            transitionDuration: const Duration(seconds: 1),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          // Increase horizontal padding
                          // ignore: prefer_const_constructors
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 25.w),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFDE0A1E)),
                      ),
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.w, 1.h, 3.w, 0),
                  child: Material(
                    elevation: 10.0,
                    shadowColor: Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          // Increase horizontal padding
                          // ignore: prefer_const_constructors
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 26.w),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black12),
                      ),
                      child: Text(
                        'No',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
