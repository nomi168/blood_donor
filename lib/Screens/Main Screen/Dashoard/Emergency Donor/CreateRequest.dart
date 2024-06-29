// ignore_for_file: file_names

import 'package:blood_donor/Screens/Main%20Screen/Dashoard/Dashboatd.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CreateRequesr extends StatefulWidget {
  const CreateRequesr({super.key});

  @override
  State<CreateRequesr> createState() => _CreateRequesrState();
}

class _CreateRequesrState extends State<CreateRequesr> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController hospital = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: ListView(
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
                    padding: EdgeInsets.fromLTRB(11.w, 1.h, 0, 0),
                    child: Text(
                      'Create A Request',
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
                  borderRadius:
                      BorderRadius.circular(10.0), // Add border radius
                  child: TextFormField(
                    controller: hospital,
                    decoration: InputDecoration(
                      label: const Text('Search Hospital'),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0), // Adjust padding
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                            color: Colors.grey), // Border color
                      ),
                      suffixIcon: const Icon(Icons.local_hospital),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                            color: Colors.blue), // Border color when focused
                      ),
                      hintText: 'Search Hospital',
                    ),
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
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                ),
                                suffixIcon: const Icon(Icons.calendar_today),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
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
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                ),
                                suffixIcon: const Icon(Icons.access_time),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                ),
                                hintText: 'Select Time',
                              ),
                              onTap: () => _selectTime(context),
                            ),
                          ))),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0),
                child: Material(
                  elevation: 7.0, // Add shadow/elevation
                  borderRadius:
                      BorderRadius.circular(10.0), // Add border radius
                  child: TextFormField(
                    decoration: InputDecoration(
                      label: const Text('Address'),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0), // Adjust padding
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                            color: Colors.grey), // Border color
                      ),
                      suffixIcon: const Icon(Icons.location_city),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                            color: Colors.blue), // Border color when focused
                      ),
                      hintText: 'Address',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0),
                child: Material(
                  elevation: 7.0,
                  borderRadius: BorderRadius.circular(10.0),
                  // ignore: sized_box_for_whitespace
                  child: TextFormField(
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
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0),
                child: Material(
                  elevation: 7.0, // Add shadow/elevation
                  borderRadius:
                      BorderRadius.circular(10.0), // Add border radius
                  child: TextFormField(
                    decoration: InputDecoration(
                      label: const Text('Blood Group'),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0), // Adjust padding
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                            color: Colors.grey), // Border color
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
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 15.h, 5.w, 0),
                child: Material(
                  elevation: 10.0,
                  shadowColor: Colors.black,
                  borderRadius: BorderRadius.circular(10.0),
                  child: ElevatedButton(
                    onPressed: _showDonatePopup,
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
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFFDE0A1E)),
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
      );
    });
  }

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
                  'images/svg1.png',
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
                  onPressed: () {
                    // variables.location = widget.Name;
                    // variables.name = widget.name;
                    // variables.distance = widget.distance;
                    // variables.blood = widget.blood;
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
}
