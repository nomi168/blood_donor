// ignore_for_file: file_names

import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:blood_donor/Json%20Data/GoogleMapDark.dart';
import 'package:blood_donor/Modals/AcceptDonator.dart';
import 'package:blood_donor/Screens/Main%20Screen/Dashoard/Dashboatd.dart';
import 'package:blood_donor/Screens/Main%20Screen/SendRequestForBood/NearByDonorMap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class MapScreen extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String Name;
  // ignore: non_constant_identifier_names
  const MapScreen({super.key, required this.Name});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
    zoom: 10.0,
  );

  // Set<Polygon> polygons = {};
  Set<Polygon> polygons = HashSet<Polygon>();
  Set<Circle> circles = {};
  final Set<Marker> _markers = {};
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  bool isLightMode = false;
  List<AcceptDonator> feedsData = [];
  String name = '';
  String blood = '';
  String image = '';
  String rating = '';
  double dis = 0.0;
  LatLng sourceLocation = LatLng(33.4951, 73.1969); // Default source location
  // LatLng destination = LatLng(33.5969, 73.0528);
  // static LatLng sourceLocation = LatLng(33.4951, 73.1969);
  // static LatLng destination = LatLng(33.5969, 73.0528);
  List<LatLng> polyline = [];

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
    toController.text = widget.Name;
    // ignore: avoid_print
    print(widget.Name);
    getAcceptDonationWithHighestRating();

    getAcceptDonationData();
    // getAceeptDonation();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            // IconButton to show path
            IconButton(
              onPressed: () {},
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
                  _toggleMapMode();
                });
              },
            ),
          ],
        ),
        body: DraggableBottomSheet(
          minExtent: 150,
          useSafeArea: false,
          curve: Curves.easeIn,
          previewWidget: _previewWidget(),
          expandedWidget: _expandedWidget(),
          backgroundWidget: _googleMap(),
          maxExtent: MediaQuery.of(context).size.height * 0.8,
          onDragging: (pos) {},
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
      String to = toController.text;
      String from = fromController.text;

      List<Location> fromLocations = await locationFromAddress(from);
      List<Location> toLocations = await locationFromAddress(to);

      if (fromLocations.isNotEmpty && toLocations.isNotEmpty) {
        Location fromLocation = fromLocations.first;
        Location toLocation = toLocations.first;

        final String apiKey =
            "AIzaSyDt9_n1OFp-s3aVJbr0ZsEAjaZPt-FoPaw"; // Replace with your actual API key
        String url =
            "https://maps.googleapis.com/maps/api/directions/json?origin=${fromLocation.latitude},${fromLocation.longitude}&destination=${toLocation.latitude},${toLocation.longitude}&key=$apiKey";
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final directions = json.decode(response.body);
          List<dynamic> routes = directions['routes'];
          if (routes.isNotEmpty) {
            List<LatLng> points = _decodePolyline(
                directions['routes'][0]['overview_polyline']['points']);
            setState(() {
              polyline = points;
            });
          } else {
            print("No routes found for the provided locations.");
          }
        } else {
          throw "Failed to fetch directions";
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<PointLatLng> decoded = PolylinePoints().decodePolyline(encoded);
    return decoded
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  // Future<void> showPath() async {
  //   try {
  // String from = fromController.text;
  //     String to = toController.text;

  //     List<Location> fromLocations = await locationFromAddress(from);
  //     List<Location> toLocations = await locationFromAddress(to);

  //     if (fromLocations.isNotEmpty && toLocations.isNotEmpty) {
  //       Location fromLocation = fromLocations.first;

  //       // Let the user choose the correct "To" location from multiple results
  //       Location? toLocation = await _chooseLocation(toLocations);

  //       if (toLocation != null) {
  //         // ignore: unused_local_variable
  //         final GoogleMapController controller = await _controller.future;

  //         LatLng fromLatLng =
  //             LatLng(fromLocation.latitude, fromLocation.longitude);
  //         LatLng toLatLng = LatLng(toLocation.latitude, toLocation.longitude);

  //         // ignore: unused_local_variable
  //         LatLngBounds bounds = LatLngBounds(
  //           southwest: fromLatLng,
  //           northeast: toLatLng,
  //         );

  //         // Comment out the line below to prevent the camera from moving
  //         // controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));

  //         // ignore: unused_local_variable
  //         PolylinePoints poly = PolylinePoints();
  //         PolylineResult result = await poly.getRouteBetweenCoordinates(
  //             "AIzaSyDt9_n1OFp-s3aVJbr0ZsEAjaZPt-FoPaw",
  //             PointLatLng(fromLocation.latitude, fromLocation.longitude),
  //             PointLatLng(toLocation.latitude, toLocation.longitude));
  //         if (result.points.isNotEmpty) {
  //           result.points.forEach((PointLatLng point) =>
  //               polyline.add(LatLng(point.latitude, point.longitude)));
  //           print("Nomi");
  //           log("Nomi");
  //           setState(() {});
  //         }

  //         setState(() {
  //           circles.clear();
  //           circles.add(Circle(
  //             circleId: const CircleId('CurrentLocationCircle'),
  //             center: fromLatLng,
  //             radius: 120.0,
  //             fillColor: Colors.blue.withOpacity(0.3),
  //             strokeColor: Colors.blue,
  //             strokeWidth: 10,
  //           ));
  //           circles.add(Circle(
  //             circleId: const CircleId('DestinationCircle'),
  //             center: toLatLng,
  //             radius: 120.0,
  //             fillColor: Colors.green.withOpacity(0.3),
  //             strokeColor: Colors.green,
  //             strokeWidth: 10,
  //           ));
  //           polygons.clear();
  //           polygons.add(Polygon(
  //             polygonId: const PolygonId('PathPolygon'),
  //             points: [fromLatLng, toLatLng],
  //             fillColor: const Color(0xFFDE0A1E).withOpacity(0.5),
  //             strokeWidth: 2,
  //             strokeColor: const Color(0xFFDE0A1E),
  //           ));
  //         });

  //         // ignore: await_only_futures
  //         double distance = await Geolocator.distanceBetween(
  //           fromLocation.latitude,
  //           fromLocation.longitude,
  //           toLocation.latitude,
  //           toLocation.longitude,
  //         );

  //         double distanceInKm = distance / 1000;

  //         setState(() {
  //           dis = distanceInKm;
  //         });

  //         // ignore: use_build_context_synchronously
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('Distance: ${distanceInKm.toStringAsFixed(2)} km'),
  //           ),
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print("Error: $e");
  //   }
  // }

  //   Future<void> _showPath() async {
  //   try {
  //     String from = fromController.text;
  //     String to = toController.text;

  //     List<Location> fromLocations = await locationFromAddress(from);
  //     List<Location> toLocations = await locationFromAddress(to);

  //     if (fromLocations.isNotEmpty && toLocations.isNotEmpty) {
  //       Location fromLocation = fromLocations.first;

  //       // Let the user choose the correct "To" location from multiple results
  //       Location? toLocation = await _chooseLocation(toLocations);

  //       if (toLocation != null) {
  //         final GoogleMapController controller = await _controller.future;

  //         LatLng fromLatLng =
  //             LatLng(fromLocation.latitude!, fromLocation.longitude!);
  //         LatLng toLatLng = LatLng(toLocation.latitude!, toLocation.longitude!);

  //         // Calculate route
  //         List<LatLng> routeCoordinates =
  //             await _getRouteCoordinates(fromLatLng, toLatLng);

  //         setState(() {
  //           _markers.clear();
  //           polylines.clear();

  //           _markers.add(
  //             Marker(
  //               markerId: MarkerId('FromMarker'),
  //               position: fromLatLng,
  //               icon: BitmapDescriptor.defaultMarkerWithHue(
  //                   BitmapDescriptor.hueAzure),
  //             ),
  //           );

  //           _markers.add(
  //             Marker(
  //               markerId: MarkerId('ToMarker'),
  //               position: toLatLng,
  //               icon: BitmapDescriptor.defaultMarkerWithHue(
  //                   BitmapDescriptor.hueGreen),
  //             ),
  //           );

  //           polylines.add(
  //             Polyline(
  //               polylineId: PolylineId('Route'),
  //               color: Colors.blue,
  //               width: 5,
  //               points: routeCoordinates,
  //             ),
  //           );
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }

  // Future<List<LatLng>> _getRouteCoordinates(
  //     LatLng fromLatLng, LatLng toLatLng) async {
  //   List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates(
  //     googleApiKey, // Your Google API key
  //     fromLatLng.latitude,
  //     fromLatLng.longitude,
  //     toLatLng.latitude,
  //     toLatLng.longitude,
  //   );

  //   List<LatLng> routeCoordinates = [];
  //   if (result.isNotEmpty) {
  //     for (PointLatLng point in result) {
  //       routeCoordinates.add(LatLng(point.latitude, point.longitude));
  //     }
  //   }
  //   return routeCoordinates;
  // }

// Future<void> showPath() async {
//   try {
//     String from = fromController.text;
//     String to = toController.text;

//     List<Location> fromLocations = await locationFromAddress(from);
//     List<Location> toLocations = await locationFromAddress(to);

//     if (fromLocations.isNotEmpty && toLocations.isNotEmpty) {
//       Location fromLocation = fromLocations.first;

//       // Let the user choose the correct "To" location
//       Location? toLocation = await _chooseLocation(toLocations);

//       if (toLocation != null) {
//         final GoogleMapController controller = await _controller.future;

//         LatLng fromLatLng = LatLng(fromLocation.latitude, fromLocation.longitude);
//         LatLng toLatLng = LatLng(toLocation.latitude, toLocation.longitude);

//         // Clear existing markers before drawing new path
//         setState(() {
//           circles.clear();
//           polygons.clear();
//         });

//         // Get directions using a suitable Directions API (replace with your implementation)
//         DirectionsResult directionsResult =  getDirections(fromLatLng, toLatLng);
//         if (directionsResult.r) {
//           print("No directions found");
//           return;
//         }

//         // Extract the first route for display
//         DirectionsWaypoint firstWaypoint = directionsResult.routes.first.legs.first.waypointList.first;
//         LatLng firstWaypointLatLng = LatLng(firstWaypoint.location.latitude, firstWaypoint.location.longitude);

//         // Draw markers at origin and first waypoint (consider adding a destination marker too)
//         setState(() {
//           circles.add(Circle(
//             circleId: const CircleId('CurrentLocationCircle'),
//             center: fromLatLng,
//             radius: 120.0,
//             fillColor: Colors.blue.withOpacity(0.3),
//             strokeColor: Colors.blue,
//             strokeWidth: 10,
//           ));
//           circles.add(Circle(
//             circleId: const CircleId('WaypointCircle'),
//             center: firstWaypointLatLng,
//             radius: 120.0,
//             fillColor: Colors.yellow.withOpacity(0.3),
//             strokeColor: Colors.yellow,
//             strokeWidth: 10,
//           ));
//         });

//         // Draw the path using a Polyline
//         List<LatLng> pathPoints = []; // Empty list to store path coordinates
//         for (LatLng legPoint in directionsResult.routes.first.legs.first.steps.fold<List<LatLng>>([], (prev, step) => prev..addAll(step.polyline.decodePoints()))) {
//           pathPoints.add(legPoint);
//         }

//         setState(() {
//           polygons.add(
//             Polygon(
//               polygonId: const PolygonId('PathPolygon'),
//               points: pathPoints,
//               fillColor: Colors.red.withOpacity(0.1),
//               strokeColor: Colors.deepOrange,
//               strokeWidth: 2,
//               geodesic: true,
//             ),
//           );
//         });

//         // Calculate distance (consider using directionsResult for more accurate distance)
//         double distance = await Geolocator.distanceBetween(
//           fromLocation.latitude,
//           fromLocation.longitude,
//           toLocation.latitude,
//           toLocation.longitude,
//         );
//         double distanceInKm = distance / 1000;
//         dis = distanceInKm;

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Distance: ${distanceInKm.toStringAsFixed(2)} km'),
//           ),
//         );
//       }
//     }
//   } catch (e) {
//     print("Error: $e");
//   }
// }

  // Future<void> showPath() async {
  //   try {
  //     String from = fromController.text;
  //     String to = toController.text;

  //     List<Location> fromLocations = await locationFromAddress(from);
  //     List<Location> toLocations = await locationFromAddress(to);

  //     if (fromLocations.isNotEmpty && toLocations.isNotEmpty) {
  //       Location fromLocation = fromLocations.first;

  //       // Let the user choose the correct "To" location from multiple results
  //       Location? toLocation = await _chooseLocation(toLocations);

  //       if (toLocation != null) {
  //         // ignore: unused_local_variable
  //         final GoogleMapController controller = await _controller.future;

  //         LatLng fromLatLng =
  //             LatLng(fromLocation.latitude, fromLocation.longitude);
  //         LatLng toLatLng = LatLng(toLocation.latitude, toLocation.longitude);

  //         // ignore: unused_local_variable
  //         LatLngBounds bounds = LatLngBounds(
  //           southwest: fromLatLng,
  //           northeast: toLatLng,
  //         );

  //         // ignore: unused_local_variable
  //         Polyline polyline = Polyline(
  //           polylineId: const PolylineId('Path'),
  //           color: Colors.red,
  //           points: [fromLatLng, toLatLng],
  //         );

  //         setState(() {
  //           circles.clear();
  //           circles.add(Circle(
  //             circleId: const CircleId('CurrentLocationCircle'),
  //             center: fromLatLng,
  //             radius: 120.0,
  //             fillColor: Colors.blue.withOpacity(0.3),
  //             strokeColor: Colors.blue,
  //             strokeWidth: 10,
  //           ));
  //           circles.add(Circle(
  //             circleId: const CircleId('DestinationCircle'),
  //             center: toLatLng,
  //             radius: 120.0,
  //             fillColor: Colors.green.withOpacity(0.3),
  //             strokeColor: Colors.green,
  //             strokeWidth: 10,
  //           ));
  //           polygons.clear();

  //           polygons.add(
  //             Polygon(
  //               polygonId: const PolygonId('1'),
  //               points: [fromLatLng, toLatLng],
  //               fillColor: Colors.red.withOpacity(0.1),
  //               strokeColor: Colors.deepOrange,
  //               strokeWidth: 2,
  //               geodesic: true,
  //             ),
  //           );
  //           // polygons.add(Polygon(
  //           //   polygonId: const PolygonId('PathPolygon'),
  //           //   points: [fromLatLng, toLatLng],
  //           //   fillColor: const Color(0xFFDE0A1E).withOpacity(0.5),
  //           //   strokeWidth: 2,
  //           //   strokeColor: const Color(0xFFDE0A1E),
  //           // ));
  //         });

  //         // ignore: await_only_futures
  //         double distance = await Geolocator.distanceBetween(
  //           fromLocation.latitude,
  //           fromLocation.longitude,
  //           toLocation.latitude,
  //           toLocation.longitude,
  //         );

  //         double distanceInKm = distance / 1000;
  //         dis = distanceInKm;

  //         // ignore: use_build_context_synchronously
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('Distance: ${distanceInKm.toStringAsFixed(2)} km'),
  //           ),
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print("Error: $e");
  //   }
  // }

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
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const Dashboard();
                        },
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

  Widget _previewWidget() {
    return Container(
      height: 20.h,
      width: 100.w,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(35.w, 0.h, 36.w, 0),
          child: const Divider(
            thickness: 4,
            color: Colors.black38,
            height: 1,
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(20.w, 1.h, 20.w, 0),
            child: const Text(
              'Swipe up for more',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
            )),
        Padding(
          padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 0),
          child: Container(
            height: 11.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(4.w, 1.h, 0, 0),
                  child: CircleAvatar(
                      radius: 30, backgroundImage: NetworkImage(image)),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(25.w, 1.h, 0, 0),
                    child: Text(
                      name,
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF353535)),
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(25.w, 4.h, 0, 0),
                    child: Text(
                      'Distance: ${dis.toStringAsFixed(2)} km',
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    )),
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
                        rating,
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFDE0A1E)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(73.w, 4.h, 0, 0),
                  child: Text(
                    blood,
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFDE0A1E)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _expandedWidget() {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 0),
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: feedsData.length,
                itemBuilder: (context, index) {
                  // ignore: unused_local_variable
                  AcceptDonator acceptDonator = feedsData[index];
                  return GestureDetector(
                    onTap: () {
                      int id = feedsData[index].id;
                      String Name = widget.Name;
                      String name = feedsData[index].name;
                      String image = feedsData[index].image;
                      String blood = feedsData[index].blood;
                      String rating = feedsData[index].rating;
                      String date = feedsData[index].date;
                      String time = feedsData[index].time;

                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return NearByDonorMap(
                                id: id,
                                Name: Name,
                                name: name,
                                image: image,
                                blood: blood,
                                rating: rating,
                                date: date,
                                time: time);
                          },
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
                    child: Card(
                      shadowColor: const Color.fromARGB(255, 235, 234, 235),
                      elevation: 10,
                      color: const Color.fromARGB(255, 245, 241, 241),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(4.w, 2.h, 0, 0),
                            child: CircleAvatar(
                              radius: 36,
                              backgroundImage: NetworkImage(image),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(30.w, 2.h, 0, 0),
                              child: Text(
                                feedsData[index].name,
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF353535)),
                              )),
                          Padding(
                              padding: EdgeInsets.fromLTRB(30.w, 5.h, 0, 0),
                              child: Text(
                                '0${int.parse(feedsData[index].number.toString())}',
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF353535)),
                              )),
                          Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(30.w, 9.h, 0, 0),
                                  // ignore: prefer_const_constructors
                                  child: Icon(
                                    Icons.star,
                                    color: const Color(0xFFDE0A1E),
                                  )),
                              Padding(
                                padding: EdgeInsets.fromLTRB(2.w, 9.h, 0, 0),
                                child: Text(
                                  feedsData[index].rating.toString(),
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFDE0A1E)),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(55.w, 9.h, 0, 0),
                                  child: Icon(
                                    Icons.bloodtype,
                                    color: Colors.red[600],
                                  )),
                              Padding(
                                padding: EdgeInsets.fromLTRB(2.w, 9.h, 0, 0),
                                child: Text(
                                  feedsData[index].blood,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFDE0A1E)),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5,
                  mainAxisExtent: 130,
                  // Adjust aspect ratio as needed
                ),
              ),
            ),
          ],
        ));
  }

  // ignore: non_constant_identifier_names
  Widget _googleMap() {
    return GoogleMap(
      mapType: isLightMode ? MapType.normal : MapType.hybrid,
      initialCameraPosition: CameraPosition(
        target: sourceLocation,
        zoom: 10.0,
      ),
      polylines: {
        Polyline(
          polylineId: PolylineId('route'),
          points: polyline,
          color: Colors.blue, // Adjust polyline color if needed
          width: 4,
        ),
      },
      circles: circles,
      polygons: polygons,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  // Future<void> getPolyPoints() async {
  //   PolylinePoints poly = PolylinePoints();
  //   PolylineResult result = await poly.getRouteBetweenCoordinates(
  //       "AIzaSyBCP8lAN_jVEdyBmuy6ef6aS9eMtu9IwdQ",
  //       PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
  //       PointLatLng(destination.latitude, destination.longitude));
  //   if (result.points.isNotEmpty) {
  //     result.points.forEach((PointLatLng point) =>
  //         polyline.add(LatLng(point.latitude, point.longitude)));
  //     print("Nomi");
  //     log("Nomi");
  //     setState(() {});
  //   }
  // }

  Future<void> getAcceptDonationData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .orderBy('acceptrating', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print('nomi');
        setState(() {
          feedsData = querySnapshot.docs.map((doc) {
            return AcceptDonator(
              id: doc['id'],
              name: doc['acceptname'],
              image: doc['acceptimage'],
              blood: doc['acceptblood'],
              number: doc['acceptnumber'],
              email: doc['acceptemail'],
              rating: doc['acceptrating'],
              time: doc['time1'],
              date: doc['date1'],
            );
          }).toList();
        });
      } else {
        print('No documents found in the taker collection');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  Future<void> getAcceptDonationWithHighestRating() async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String userEmail = prefs.getString('user_email') ?? '';
      // print(userEmail);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')

          // .orderBy('acceptrating', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        String acceptName = userDoc['acceptname'];
        String acceptPic = userDoc['acceptimage'];
        String acceptRating = userDoc['acceptrating'];
        String acceptBlood = userDoc['acceptblood'];

        setState(() {
          name = acceptName;
          image = acceptPic;
          rating = acceptRating;
          blood = acceptBlood;
        });
      } else {
        print('No user found with the highest rating');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
