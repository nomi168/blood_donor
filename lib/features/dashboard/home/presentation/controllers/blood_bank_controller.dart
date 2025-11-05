import 'dart:convert';

import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/dashboard/home/data/models/blood_bank_model.dart';
import 'package:blood_donor/features/dashboard/home/domain/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;

class BloodBankController extends GetxController {
  final HomeRepository _homeRepository = HomeRepository();
  TextEditingController searchController = TextEditingController();
  List<BloodBank> bloodBankList = [];
  List<BloodBank>? filterList;
  bool isLoading = false;
  String? selectedGroup;

  @override
  void onInit() {
    getBloodBanksList();
    super.onInit();
  }

  final List<String> bloodGroups = [
    "A+",
    "B+",
    "O+",
    "AB+",
    "A-",
    "B-",
    "O-",
    "AB-"
  ];

  Future<void> getBloodBanksList() async {
    bloodBankList.clear();
    isLoading = true;
    bloodBankList = await getBloodBanks();
    isLoading = false;
    update();
  }

  void filterUsers(String? query) {
    if (query == null || query.isEmpty) {
      filterList = List.from(bloodBankList);
    } else {
      final lowerQuery = query.toLowerCase();
      filterList = bloodBankList.where((user) {
        return user.name.toLowerCase().contains(lowerQuery);
      }).toList();
    }
    update();
  }

  Future<void> showLocationPopup(
      BuildContext context, String bloodLocation) async {
    showLoader('opening map...');
    Completer<GoogleMapController> _controller = Completer();
    LatLng bloodLatLng = await convertAddressToLatLng(bloodLocation);

    // Get donor's current location
    Position donorPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    LatLng donorLatLng =
        LatLng(donorPosition.latitude, donorPosition.longitude);

    // Polyline setup
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> polylineCoordinates = [];
    String distanceText = "";
    String durationText = "";

    // ✅ Get route for drawing polyline
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: "AIzaSyAn6fh8krl1H-wflk6gHJ2aWoFEGAuaseI",
      request: PolylineRequest(
        origin: PointLatLng(donorLatLng.latitude, donorLatLng.longitude),
        destination: PointLatLng(bloodLatLng.latitude, bloodLatLng.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      // ✅ Fetch distance & duration from API
      Map<String, String> info = await getDistanceAndDuration(
        donorLatLng,
        bloodLatLng,
        "AIzaSyAn6fh8krl1H-wflk6gHJ2aWoFEGAuaseI",
      );
      distanceText = info["distance"] ?? "";
      durationText = info["duration"] ?? "";
    }

    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId("donor"),
        position: donorLatLng,
        infoWindow: const InfoWindow(title: "Donor Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
      Marker(
        markerId: const MarkerId("blood_bank"),
        position: bloodLatLng,
        infoWindow: const InfoWindow(title: "Blood Bank"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };

    Set<Polyline> polylines = {
      Polyline(
        polylineId: const PolylineId("route"),
        color: Colors.blue,
        width: 5,
        points: polylineCoordinates,
      ),
    };

    showDialog(
      context: context,
      builder: (ctx) {
        EasyLoading.dismiss();
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ✅ Back button to close popup
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          CupertinoIcons.back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),

                      const Text(
                        "Donor → Blood Bank",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const Icon(
                        CupertinoIcons.location,
                        color: Colors.white,
                        size: 22,
                      ),
                    ],
                  ),
                ),

                if (distanceText.isNotEmpty && durationText.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.grey.shade100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.social_distance,
                                color: Colors.blue),
                            const SizedBox(width: 6),
                            Text("Distance: $distanceText"),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.timer, color: Colors.red),
                            const SizedBox(width: 6),
                            Text("Time: $durationText"),
                          ],
                        ),
                      ],
                    ),
                  ),

                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: donorLatLng,
                      zoom: 13,
                    ),
                    markers: markers,
                    polylines: polylines,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, String>> getDistanceAndDuration(
      LatLng origin, LatLng destination, String apiKey) async {
    final url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=driving&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data["status"] == "OK") {
      final leg = data["routes"][0]["legs"][0];
      String distanceText = leg["distance"]["text"];
      String durationText = leg["duration"]["text"];

      return {
        "distance": distanceText,
        "duration": durationText,
      };
    } else {
      throw Exception("Error fetching directions: ${data["status"]}");
    }
  }

  Future<LatLng> convertAddressToLatLng(String address) async {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      return LatLng(locations.first.latitude, locations.first.longitude);
    }
    throw Exception("Address not found");
  }

  Future<List<BloodBank>> getBloodBanks() async {
    try {
      return await _homeRepository.getBloodBanks();
    } catch (e) {
      Helper.handleError(e, 'Error while getting blood bank data!');
      return [];
    }
  }
}
