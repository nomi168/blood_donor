// ignore_for_file: file_names

import 'dart:async';

import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:blood_donor/Json%20Data/GlobalVariable.dart';
import 'package:blood_donor/Json%20Data/GoogleMapDark.dart';
import 'package:blood_donor/Screens/Main%20Screen/SendRequestForBood/SubmitReview.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

class RecievedDonor extends StatefulWidget {
  final int id;
  final String location;
  final String name;
  final String blood;
  final String image;
  final String date;
  final String rating;
  final String time;
  const RecievedDonor(
      {super.key,
      required this.location,
      required this.name,
      required this.blood,
      required this.image,
      required this.date,
      required this.rating,
      required this.time,
      required this.id});

  @override
  State<RecievedDonor> createState() => _RecievedDonorState();
}

class _RecievedDonorState extends State<RecievedDonor> {
// final GlobalKey<AnotherStepper> stepperKey = GlobalKey();

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
  int selectedRating = -1;
  double dis = 0.0;
  String date = '';
  String time = '';

  List<StepperData> stepperData = [
    StepperData(
        title: StepperText(
          "Request Accepted",
          textStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: StepperText('Schedule-${variables.date}, ${variables.time}'),
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
              color: Colors.black45,
              borderRadius: BorderRadius.all(Radius.circular(30))),
        )),
    StepperData(
        title: StepperText("Share your Feedback",
            textStyle: const TextStyle(color: Colors.grey)),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.all(Radius.circular(30))),
        )),
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    toController.text = widget.location;
    showPath();
    date = widget.date;
    time = widget.time;
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
              height: 30.h,
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
                  activeIndex: 2,
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
                padding: EdgeInsets.fromLTRB(5.w, 81.h, 5.w, 0.h),
                child: SizedBox(
                  height: 7.h,
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
                                onPressed: () {},
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
                                  'Received',
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
          dis = distanceInKm;

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
        ));
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            'You have Successfully received blood from your donor',
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
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return SubmitReview(
                                  id: id,
                                  loc: location,
                                  name: name,
                                  blood: blood,
                                  image: image,
                                  date: date,
                                  rating: rating,
                                  time: time);
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
