// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'PaymentDetail.dart';
// import 'package:file_picker/file_picker.dart';

class OrderDetail extends StatefulWidget {
  final String name;
  final String location;
  final String number;
  final String image;
  final String blood;
  const OrderDetail(
      {super.key,
      required this.name,
      required this.location,
      required this.number,
      required this.image,
      required this.blood});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController name = TextEditingController();
  TextEditingController image = TextEditingController();
  TextEditingController blood = TextEditingController();

  TextEditingController location = TextEditingController();
  TextEditingController phone = TextEditingController();

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

  // Future<void> pickFile() async {
  //   final result = await FilePicker.platform.pickFiles();

  //   if (result != null) {
  //     setState(() {
  //       hospital.text = result.files.first.name; // Extracting file name
  //     });
  //   }
  // }
// //
//   @override
//   void dispose() {
//     hospital.dispose();
//     super.dispose();
//   }
  @override
  void initState() {
    super.initState();
    name.text = widget.name;
    image.text = widget.image;
    phone.text = widget.number;
    location.text = widget.location;
    blood.text = widget.blood;
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
                    padding: EdgeInsets.fromLTRB(18.w, 1.h, 0, 0),
                    child: Text(
                      'Order Detail',
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
                    controller: name,
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
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
                child: Material(
                  elevation: 7.0, // Add shadow/elevation
                  borderRadius:
                      BorderRadius.circular(10.0), // Add border radius
                  child: TextFormField(
                    controller: phone,
                    decoration: InputDecoration(
                      label: const Text('Phone Number'),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0), // Adjust padding
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                            color: Colors.grey), // Border color
                      ),
                      suffixIcon: const Icon(Icons.phone_callback),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                            color: Colors.blue), // Border color when focused
                      ),
                      hintText: 'Enter Phone Number',
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
                    controller: location,
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
                    controller: image,
                    decoration: InputDecoration(
                      label: const Text('Select File'),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0), // Adjust padding
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                            color: Colors.grey), // Border color
                      ),
                      suffixIcon: const Icon(Icons.attach_file),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                            color: Colors.blue), // Border color when focused
                      ),
                      hintText: 'Select File',
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
                    controller: blood,
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
                padding: EdgeInsets.fromLTRB(5.w, 25.h, 5.w, 0),
                child: Material(
                  elevation: 10.0,
                  shadowColor: Colors.black,
                  borderRadius: BorderRadius.circular(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const PaymentDetail();
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
                      'Continue',
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
}
