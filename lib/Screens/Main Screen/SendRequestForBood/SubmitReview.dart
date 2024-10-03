// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';

import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:blood_donor/Json%20Data/GlobalVariable.dart';
import 'package:blood_donor/Json%20Data/GoogleMapDark.dart';
import 'package:blood_donor/Screens/Main%20Screen/Dashoard/Dashboatd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SubmitReview extends StatefulWidget {
  final int id;
  final String name;
  final String blood;
  final String image;
  final String date;
  final String rating;
  final String time;
  final String loc;

  const SubmitReview(
      {super.key,
      required this.name,
      required this.blood,
      required this.image,
      required this.date,
      required this.rating,
      required this.time,
      required this.loc,
      required this.id});

  @override
  State<SubmitReview> createState() => _SubmitReviewState();
}

class _SubmitReviewState extends State<SubmitReview> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
    zoom: 10.0,
  );

  Set<Polygon> polygons = {};
  Set<Circle> circles = {};

  Set<Polyline> polylines = {};
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  TextEditingController reviews = TextEditingController();
  bool isLightMode = false;
  int selectedRating = -1;
  double rati = 0.0;
  String rat = '';
  double dis = 0.0;
  List<StepperData> stepperData = [
    StepperData(
        title: StepperText(
          "Request Accepted",
          textStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: StepperText("Schedule-${variables.date}, ${variables.time}"),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              color: Color(0xFFDE0A1E),
              borderRadius: BorderRadius.all(Radius.circular(30))),
        )),
    StepperData(
        title: StepperText(
          "Donor is on the way",
          textStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: StepperText("Estimating ariving time 30.00 min"),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              color: Color(0xFFDE0A1E),
              borderRadius: BorderRadius.all(Radius.circular(30))),
        )),
    StepperData(
        title: StepperText("Donor has reached the destination"),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              color: Color(0xFFDE0A1E),
              borderRadius: BorderRadius.all(Radius.circular(30))),
        )),
    StepperData(
        title: StepperText("Share your Feedback",
            textStyle: const TextStyle(color: Colors.grey)),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              color: Color(0xFFDE0A1E),
              borderRadius: BorderRadius.all(Radius.circular(30))),
        )),
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    toController.text = widget.loc;

    variables.date = widget.date;
    variables.time = widget.time;
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
                onPressed: () {
                  showPath(widget.loc);
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
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(children: [
              Container(
                color: const Color.fromRGBO(244, 67, 54, 1),
                height: 30.h,
                width: 100.w,
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
                padding: EdgeInsets.fromLTRB(5.w, 25.h, 5.w, 0),
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
                            backgroundImage: NetworkImage(widget.image),
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
                          padding: EdgeInsets.fromLTRB(27.w, 3.5.h, 0, 3.h),
                          child: Text(
                            'Distance: ${dis.toStringAsFixed(2)} km',
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )),
                      Padding(
                          padding: EdgeInsets.fromLTRB(27.w, 6.h, 0, 3.h),
                          child: const Icon(Icons.star,
                              size: 20, color: Color(0xFFDE0A1E))),
                      Padding(
                          padding: EdgeInsets.fromLTRB(34.w, 6.h, 0, 3.h),
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
                  padding: EdgeInsets.fromLTRB(0, 36.h, 10.w, 0),
                  child: AnotherStepper(
                    // key: stepperKey,
                    stepperList: stepperData,
                    stepperDirection: Axis.vertical,
                    iconWidth: 25,
                    iconHeight: 25,
                    activeBarColor: const Color(0xFFDE0A1E),
                    inActiveBarColor: Colors.grey,
                    inverted: false,
                    verticalGap: 15,
                    activeIndex: 4,
                    barThickness: 3,
                    scrollPhysics: const AlwaysScrollableScrollPhysics(),
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 5.h, 0, 0.h),
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
                padding: EdgeInsets.fromLTRB(5.w, 70.h, 5.w, 0),
                child: Material(
                  elevation: 7.0,
                  borderRadius: BorderRadius.circular(10.0),
                  child: TextField(
                    controller: reviews,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 25.0),
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
                padding: EdgeInsets.fromLTRB(10.w, 81.h, 5.w, 0),
                child: Material(
                  elevation: 10.0,
                  shadowColor: Colors.black,
                  borderRadius: BorderRadius.circular(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      updateAcceptDonationData();
                      // ignore: non_constant_identifier_names
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        // Increase horizontal padding
                        // ignore: prefer_const_constructors
                        EdgeInsets.symmetric(vertical: 2.2.h, horizontal: 25.w),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFFDE0A1E)),
                    ),
                    child: Text(
                      'Submit Your Review',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
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
      await showPath(widget.loc);
    } catch (e) {
      // ignore: avoid_print
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

  Future<void> updateAcceptDonationData() async {
    try {
      add();
      print(rat);
      print(rati);
      double r = double.parse(rat);
      double ree = (r + rati) / 2;
      print("Nomi is $ree");
      String rrr = ree.toString();

      print("Nomi is $rrr");
      // Get user data from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user_email') ?? '';

      // Query Firestore to get the document that matches the user's email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('id', isEqualTo: widget.id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document reference
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String documentId = documentSnapshot.id;

        // Update the data in the document
        await FirebaseFirestore.instance
            .collection('acceptdonation')
            .doc(documentId)
            .update({
          'acceptrating': rrr,
          'review': reviews.text,
        });
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const Dashboard();
            },
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(10.0, 0.0); // slide in from the right
              const end = Offset.zero;
              const curve = Curves.easeInOutQuart;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );

        print('Data updated successfully in acceptdonation table');
      } else {
        print('User not found with email: $userEmail');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
