import 'package:blood_donor/constants.dart';
import 'package:blood_donor/features/dashboard/Main%20Screen/SendRequestForBood/Post%20Rquest/mapcheck_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class MultipleBloodRequest extends StatefulWidget {
  String blood;
  MultipleBloodRequest({super.key, required this.blood});

  @override
  State<MultipleBloodRequest> createState() => _MultipleBloodRequestState();
}

class _MultipleBloodRequestState extends State<MultipleBloodRequest> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController hospital = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController blood = TextEditingController();
  String fullname = '';
  String picture = '';
  String rating = '0.0';
  String takerid = '';
  String nunber = '';
  String takeremail = '';
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool showCircularProgressIndicator = false;
  List<Map<String, double>> receiverLocations = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  String? validateHospital(String? value) {
    if (value == null || value.isEmpty) {
      return 'Hospital Name is required';
    }
    return null; // Indicates a valid location
  }

  String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }
    return null; // Indicates a valid location
  }

  String? validateNote(String? value) {
    if (value == null || value.isEmpty) {
      return 'Note is required';
    }
    return null; // Indicates a valid location
  }

  String? validateBlood(String? value) {
    if (value == null || value.isEmpty) {
      return 'Blood is required';
    }
    return null; // Indicates a valid location
  }

  List<dynamic> receiverIds = [];
  String name = '';

  void textdata() {
    for (int i = 0; i < receiverIds.length; i++) {
      name[i];
      setState(() {});
    }
  }

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    getUserDataByEmail();
    blood.text = widget.blood;

    textdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _form,
      child: ListView(
        children: [
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 1.h, 0, 0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 27,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(15.w, 1.h, 0, 0),
                child: Text(
                  'Post A Request',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      color: Colors.black54),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
            child: Material(
              elevation: 7.0, // Add shadow/elevation
              borderRadius: BorderRadius.circular(10.0), // Add border radius
              child: TextFormField(
                controller: hospital,
                decoration: InputDecoration(
                  label: const Text('Search Hospital'),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // Adjust padding
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Colors.grey), // Border color
                  ),
                  suffixIcon: const Icon(Icons.local_hospital),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                        color: Colors.blue), // Border color when focused
                  ),
                  hintText: 'Search Hospital',
                ),
                validator: validateHospital,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 3.h, 2.w, 0),
                      child: Material(
                        elevation: 7.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: TextEditingController(
                            text: "${selectedDate.toLocal()}".split(' ')[0],
                          ),
                          decoration: InputDecoration(
                            label: const Text('Select Date'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            suffixIcon: const Icon(Icons.calendar_today),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            hintText: 'Select Date',
                          ),
                          onTap: () => _selectDate(context),
                        ),
                      ))),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(2.w, 3.h, 5.w, 0),
                      child: Material(
                        elevation: 7.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: TextEditingController(
                            // ignore: unnecessary_string_interpolations
                            text: "${selectedTime.format(context)}",
                          ),
                          decoration: InputDecoration(
                            label: const Text('Select Time'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            suffixIcon: const Icon(Icons.access_time),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            hintText: 'Select Time',
                          ),
                          onTap: () => _selectTime(context),
                        ),
                      ))),
            ],
          ),
          // Padding(
          //   padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
          //   child: Material(
          //     elevation: 10.0,
          //     shadowColor: Colors.black,
          //     borderRadius: BorderRadius.circular(10.0),
          //     child: ElevatedButton(
          //       onPressed: () {},
          //       style: ButtonStyle(
          //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //           RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10.0),
          //           ),
          //         ),
          //         padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          //           // Increase horizontal padding
          //           // ignore: prefer_const_constructors
          //           EdgeInsets.symmetric(vertical: 2.h, horizontal: 30.w),
          //         ),
          //         backgroundColor:
          //             MaterialStateProperty.all<Color>(Colors.grey),
          //       ),
          //       child: Stack(
          //         alignment: Alignment.center,
          //         children: [
          //           Text(
          //             'Select Location',
          //             style: TextStyle(
          //               fontSize: 12.sp,
          //               fontWeight: FontWeight.bold,
          //               color: Colors.white,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0),
            child: Material(
              elevation: 7.0, // Add shadow/elevation
              borderRadius: BorderRadius.circular(10.0), // Add border radius
              child: TextFormField(
                controller: location,
                decoration: InputDecoration(
                  label: const Text('Address'),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // Adjust padding
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Colors.grey), // Border color
                  ),
                  suffixIcon: const Icon(Icons.location_city),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                        color: Colors.blue), // Border color when focused
                  ),
                  hintText: 'Address',
                ),
                validator: validateAddress,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
              'Must be enter complete address with city name!',
              style: TextStyle(fontSize: 11, color: PRIMARY_COLOR),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0),
            child: Material(
              elevation: 7.0,
              borderRadius: BorderRadius.circular(10.0),
              // ignore: sized_box_for_whitespace
              child: TextFormField(
                controller: note,
                maxLines: 5,
                mouseCursor: MouseCursor.defer,
                decoration: InputDecoration(
                  label: const Text('Note'),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  suffixIcon: const Icon(Icons.location_city),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  hintText: 'Note',
                ),
                validator: validateNote,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0),
            child: Material(
              elevation: 7.0, // Add shadow/elevation
              borderRadius: BorderRadius.circular(10.0), // Add border radius
              child: TextFormField(
                controller: blood,
                decoration: InputDecoration(
                  label: const Text('Blood Group'),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // Adjust padding
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Colors.grey), // Border color
                  ),
                  suffixIcon: const Icon(
                    Icons.bloodtype,
                    color: Color(0xFFDE0A1E),
                    size: 35.0,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                        color: Colors.blue), // Border color when focused
                  ),
                  hintText: 'Blood Group',
                ),
                validator: validateBlood,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 0),
            child: Material(
              elevation: 10.0,
              shadowColor: Colors.black,
              borderRadius: BorderRadius.circular(10.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_form.currentState?.validate() ?? false) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return MapCheckScreen(
                              takerlocation: location.text,
                              takerid: takerid,
                              fullname: fullname,
                              picture: picture,
                              takeremail: takeremail,
                              number: nunber,
                              hospitalname: hospital.text,
                              date: selectedDate
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0],
                              time: selectedTime.format(context),
                              note: note.text,
                              blood: blood.text,
                              rating: rating,
                              status: false);
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
                    // _addRequest();
                  }
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
                    EdgeInsets.symmetric(vertical: 2.h, horizontal: 32.w),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFFDE0A1E)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'Send Request',
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
    ));
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
        String id = userDoc['id'];
        String name = userDoc['firstname'];
        String name1 = userDoc['lastname'];
        String image = userDoc['image'];
        String email = userDoc['email'];
        String num = userDoc['phonenumber'];

        fullname = name + " $name1";
        picture = image;
        takeremail = email;
        nunber = num;
        takerid = id;
        print("Name is $fullname");
        print("email is $takeremail");
        print("image is $picture");
      } else {
        // No user found with the specified email
        print('User not found with email: $userEmail');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }
}
