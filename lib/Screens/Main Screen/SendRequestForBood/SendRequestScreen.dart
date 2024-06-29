// ignore_for_file: file_names

import 'dart:io';

import 'package:blood_donor/Screens/Main%20Screen/SendRequestForBood/MapScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class SendRequestScreen extends StatefulWidget {
  final String blood;
  const SendRequestScreen({super.key, required this.blood});

  @override
  State<SendRequestScreen> createState() => _SendRequestScreenState();
}

class _SendRequestScreenState extends State<SendRequestScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController hospital = TextEditingController();
  TextEditingController blood = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController address = TextEditingController();
  File? _pickedImage;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  String? _imageUrl;
  int takerid = 0;
  bool showCircularProgressIndicator = false;

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

  Future<void> _pickImage() async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
        address.text = _pickedImage!.path.toString();
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
      return 'Hospital is required';
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

  @override
  void initState() {
    super.initState();
    blood.text = widget.blood;
    getTakerId();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
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
                                  text:
                                      "${selectedDate.toLocal()}".split(' ')[0],
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
                      controller: address,
                      decoration: InputDecoration(
                        label: const Text('Attach File'),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0), // Adjust padding
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Colors.grey), // Border color
                        ),
                        suffixIcon: GestureDetector(
                          onTap: _pickImage,
                          child: Icon(Icons.attach_file),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Colors.blue), // Border color when focused
                        ),
                        hintText: 'Attach File',
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
                        if (_form.currentState!.validate()) {
                          setState(() {
                            showCircularProgressIndicator = true;
                          });
                          _uploadImage();
                        }
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
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 32.w),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFDE0A1E)),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (showCircularProgressIndicator)
                            const SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          if (!showCircularProgressIndicator)
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
          ),
        ),
      );
    });
  }

  Future<void> _uploadImage() async {
    if (_pickedImage == null) return;

    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('profile_images/${DateTime.now()}.jpg');

    final UploadTask uploadTask = storageReference.putFile(_pickedImage!);
    await uploadTask.whenComplete(() => null);

    final imageUrl = await storageReference.getDownloadURL();

    setState(() {
      _imageUrl = imageUrl;
    });
    _addRequest();
  }

  Future<void> getTakerId() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('requestdonatoin')
          .orderBy('id', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        int userId = userDoc['id'];
        takerid = userId;

        print('Taker ID: $takerid');
      } else {
        print('No documents found in the Request collection');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  void _addRequest() async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      takerid++;

      // Save user data in the 'taker' collection
      await _firestore.collection('requestdonatoin').add({
        'id': takerid,
        'hospital': hospital.text,
        'date': selectedDate.toLocal().toString().split(' ')[0],
        'time': selectedTime.format(context),
        'file': _imageUrl,
        'note': note.text,
        'blood': blood.text,
      });

      String Name = hospital.text;
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return MapScreen(
              Name: Name,
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
      setState(() {
        showCircularProgressIndicator = false;
      });
    } catch (error) {
      print("Error in _handleSignup: $error");
      // Handle error and show a proper error message to the user
    }
  }
}
