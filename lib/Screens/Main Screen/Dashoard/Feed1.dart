// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';

import 'package:blood_donor/Json%20Data/GoogleMapDark.dart';
import 'package:blood_donor/Screens/Main%20Screen/Dashoard/Dashboatd.dart';
import 'package:blood_donor/Screens/Main%20Screen/Dashoard/Review1.dart';
import 'package:blood_donor/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
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
  Set<Polyline> polylines = {};

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
    print("Nomi ${widget.takerid}");
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
      backgroundColor: Colors.white,
      body: Column(children: [
        Container(
          color: const Color.fromRGBO(244, 67, 54, 1),
          height: 30.h,
          width: double.infinity,
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
        Container(
            margin: EdgeInsets.only(top: 5),
            height: 4,
            width: 20.w,
            decoration: BoxDecoration(
              color: Colors.grey.shade500,
              borderRadius: BorderRadius.circular(10),
            )),
        SizedBox(
          height: 15,
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF3F3F3).withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 1, color: Colors.grey.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: Offset(0, 4),
                spreadRadius: 1,
              ),
            ],
          ),
          height: 10.h,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 70,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: widget.image.isNotEmpty
                        ? widget.image
                        : "https://www.lscthub.co.uk/wp-content/themes/u-design/assets/images/placeholders/event-placeholder.jpg",
                    placeholder: (context, url) =>
                        const CupertinoActivityIndicator(
                      color: Colors.white,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    widget.hospital,
                    style: TextStyle(fontSize: 11.sp, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Donation Details',
          style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF3F3F3).withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 1, color: Colors.grey.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: Offset(0, 4),
                spreadRadius: 1,
              ),
            ],
          ),
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Location-',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Text(
                    widget.location,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Schedule-',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Text(
                    widget.time,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.date,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Review-',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  buildStar(1),
                  buildStar(2),
                  buildStar(3),
                  buildStar(4),
                  buildStar(5),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF3F3F3).withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 1, color: Colors.grey.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: Offset(0, 4),
                spreadRadius: 1,
              ),
            ],
          ),
          width: double.infinity,
          height: 15.h,
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: TextField(
            controller: review,
            readOnly: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 00.0),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              hintText: 'Enter your suggestion here!',
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    await deleteAcceptRequest();
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 11),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(08),
                        border: Border.all(color: PRIMARY_COLOR)),
                    alignment: Alignment.center,
                    child: Text(
                      'Cancel Request',
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    _showConfirmationDialog(context);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 11),
                    decoration: BoxDecoration(
                        color: PRIMARY_COLOR,
                        borderRadius: BorderRadius.circular(08),
                        border: Border.all(color: PRIMARY_COLOR)),
                    alignment: Alignment.center,
                    child: Text(
                      'Continue',
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        // Padding(
        //     padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0.h),
        //     child: SizedBox(
        //       height: 6.h,
        //       width: 100.w,
        //       child: Material(
        //           borderRadius: BorderRadius.circular(10.0),
        //           elevation: 5.0,
        //           color: const Color(0xFFDE0A1E),
        //           child: Row(
        //             children: [
        //               Padding(
        //                   padding: EdgeInsets.fromLTRB(5.w, 0, 0, 0),
        //                   child: TextButton(
        //                     child: Text(
        //                       'Cancel Request',
        //                       style: TextStyle(
        //                           fontSize: 12.sp,
        //                           fontWeight: FontWeight.bold,
        //                           color: Colors.white70),
        //                     ),
        //                     onPressed: () async {
        //                       await deleteAcceptRequest();
        //                     },
        //                   )),
        //               Padding(
        //                 padding: EdgeInsets.fromLTRB(4.w, 0, 0, 0),
        //                 child: const VerticalDivider(
        //                   color: Colors.white, // Adjust the color as needed
        //                   thickness: 2.0, // Adjust the thickness as needed
        //                 ),
        //               ),
        //               Padding(
        //                   padding: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
        //                   child: TextButton(
        //                     child: Text(
        //                       'Donated',
        //                       style: TextStyle(
        //                           fontSize: 12.sp,
        //                           fontWeight: FontWeight.bold,
        //                           color: Colors.white),
        //                     ),
        //                     onPressed: () {
        //                       _showConfirmationDialog(context);
        //                     },
        //                   ))
        //             ],
        //           )),
        //     ))
      ]),
    );
  }

  Future<void> deleteAcceptRequest() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('acceptemail', isEqualTo: widget.donoremail)
          .where('email', isEqualTo: widget.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document from the query
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Delete the document using its ID
        await FirebaseFirestore.instance
            .collection('acceptdonation')
            .doc(userDoc.id)
            .delete();

        EasyLoading.showSuccess('Cancel Request Successfully');
        await Future.delayed(Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil(
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

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
            (Route<dynamic> route) =>
                false, // Predicate that removes all the routes
          );
        });
        print('Document deleted successfully');
      } else {
        EasyLoading.showError('No Cancel Request Accepted');
        print('No documents found in the Request collection');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
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
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content:
            //         Text('Distance: ${distanceInKm.toStringAsFixed(2)} km'),
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

  Widget buildStar(int starNumber) {
    return GestureDetector(
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
          backgroundColor: Colors.white,
          actions: <Widget>[
            Column(
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Image.asset('images/fi_16322725.png'),
                Container(
                  margin: EdgeInsets.only(top: 1.h),
                  child: Text(
                    'Congratulations',
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 3.h),
                  child: Text(
                    'You have Successfully donated blood to the seeker',
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.w, 3.h, 3.w, 0),
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
                        'Done',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.fromLTRB(0.w, 1.h, 3.w, 0),
                //   child: Material(
                //     elevation: 10.0,
                //     shadowColor: Colors.black,
                //     borderRadius: BorderRadius.circular(10.0),
                //     child: ElevatedButton(
                //       onPressed: () {
                //         Navigator.pop(context);
                //       },
                //       style: ButtonStyle(
                //         shape:
                //             MaterialStateProperty.all<RoundedRectangleBorder>(
                //           RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10.0),
                //           ),
                //         ),
                //         padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                //           // Increase horizontal padding
                //           // ignore: prefer_const_constructors
                //           EdgeInsets.symmetric(vertical: 2.h, horizontal: 26.w),
                //         ),
                //         backgroundColor:
                //             MaterialStateProperty.all<Color>(Colors.black12),
                //       ),
                //       child: Text(
                //         'No',
                //         style: TextStyle(
                //           fontSize: 12.sp,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.white,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            )
          ],
        );
      },
    );
  }
}
