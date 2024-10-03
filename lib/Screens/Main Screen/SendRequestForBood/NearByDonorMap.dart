// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:async';
import 'dart:convert';

import 'package:blood_donor/Json%20Data/GoogleMapDark.dart';
import 'package:blood_donor/Screens/Main%20Screen/SendRequestForBood/RecievedDonor.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class NearByDonorMap extends StatefulWidget {
  final int id;
  final String Name;
  final String name;
  final String image;
  final String rating;
  final String blood;
  final String date;
  final String time;
  final String location;

  const NearByDonorMap(
      {super.key,
      required this.Name,
      required this.name,
      required this.image,
      required this.blood,
      required this.rating,
      required this.date,
      required this.time,
      required this.id,
      required this.location});

  @override
  State<NearByDonorMap> createState() => _NearByDonorMapState();
}

class _NearByDonorMapState extends State<NearByDonorMap> {
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
  bool isLightMode = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    toController.text = widget.location;
    print('Nomi is here ${widget.Name}');
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
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
            Expanded(
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
              height: 28.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(4.w, 1.h, 0, 0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(widget.image),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(25.w, 1.h, 0, 0),
                      child: Text(
                        widget.name,
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF353535)),
                      )),
                  Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(25.w, 4.h, 0, 0),
                          child: Text(
                            'Last Donation: ${widget.date}',
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(25.w, 7.h, 0, 0),
                          // ignore: prefer_const_constructors
                          child: Icon(
                            Icons.star,
                            color: const Color(0xFFDE0A1E),
                          )),
                      Padding(
                        padding: EdgeInsets.fromLTRB(2.w, 7.h, 0, 0),
                        child: Text(
                          widget.rating,
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFDE0A1E)),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(85.w, 3.h, 0, 0),
                    child: Text(
                      widget.blood,
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFDE0A1E)),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 10.h, 0, 0),
                        child: const CircleAvatar(
                          backgroundColor: Color(0xFFDE0A1E),
                          radius: 23,
                          backgroundImage: AssetImage('images/person1.png'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.w, 10.h, 0, 0),
                        child: const CircleAvatar(
                          backgroundColor: Color(0xFFDE0A1E),
                          radius: 23,
                          backgroundImage: AssetImage('images/star.png'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.w, 10.h, 0, 0),
                        child: const CircleAvatar(
                          backgroundColor: Color(0xFFDE0A1E),
                          radius: 23,
                          backgroundImage: AssetImage('images/correct.png'),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.w, 17.h, 0, 0),
                        child: Text(
                          '6 Life Saved',
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(4.w, 17.h, 0, 0),
                        child: Text(
                          'Top Rated',
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(4.w, 17.h, 0, 0),
                        child: Text(
                          'Good Behavior',
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 20.h, 5.w, 0),
                    child: Material(
                      elevation: 10.0,
                      shadowColor: Colors.black,
                      borderRadius: BorderRadius.circular(10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _showDonatePopup();
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            // Increase horizontal padding
                            // ignore: prefer_const_constructors
                            EdgeInsets.symmetric(
                                vertical: 2.h, horizontal: 32.w),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                        ),
                        child: Text(
                          'Send Request',
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
              ),
            ),
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
                  onPressed: _showox,
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

  void _showox() {
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
                  height: 40.h,
                  width: 40.w,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your request has been accepted',
                  style: TextStyle(
                    fontSize: 15,
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
                'Track Your Donor through the blood journey map',
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
                    int id = widget.id;
                    String location = widget.location;
                    String name = widget.name;
                    String blood = widget.blood;
                    String image = widget.image;
                    String date = widget.date;
                    String rating = widget.rating;
                    String time = widget.time;
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return RecievedDonor(
                              id: id,
                              location: location,
                              name: name,
                              blood: blood,
                              image: image,
                              date: date,
                              rating: rating,
                              time: time);
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
