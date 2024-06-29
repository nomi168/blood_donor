// ignore_for_file: unused_element, prefer_final_fields, file_names

import 'dart:io';

import 'package:blood_donor/Screens/Authentication%20Screen/LoginScreen.dart';
import 'package:blood_donor/Screens/Authentication%20Screen/SimpleAuthentication.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sizer/sizer.dart';

class SimpleSignup extends StatefulWidget {
  const SimpleSignup({super.key});

  @override
  State<SimpleSignup> createState() => _SimpleSignupState();
}

class _SimpleSignupState extends State<SimpleSignup> {
  File? _image;
  List<String> nomi = ['Male', 'Female'];
  String selectedIndex = '';
  List<String> nomi1 = ['A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-', 'AB-'];
  String selectedIndex1 = '';
  String type = ''; // Default country code
  String mobileNumber = '';
  int id = 1;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController _phonenumber = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _conpassword = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _fname = TextEditingController();

  TextEditingController _lname = TextEditingController();

  // ignore: unused_field, prefer_typing_uninitialized_variables
  late final _phone;
  bool _obscureText = false;
  bool _obscureText1 = false;
  bool showCircularProgressIndicator = false;

  Future _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'First Name is required';
    } else if (!RegExp(r"^[a-zA-Z]+$").hasMatch(value)) {
      return 'Only letters are allowed';
    } else if (value.isNotEmpty && value[0].toUpperCase() != value[0]) {
      return 'First letter should be capital';
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Last Name is required';
    } else if (!RegExp(r"^[a-zA-Z]+$").hasMatch(value)) {
      return 'Only letters are allowed';
    } else if (value.isNotEmpty && value[0].toUpperCase() != value[0]) {
      return 'First letter should be capital';
    }
    return null;
  }

  String? _validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return 'Phone number is required';
    } else if (!RegExp(r"^[0-9]+$").hasMatch(value)) {
      return 'Only numbers are allowed';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r"^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$")
        .hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    } else if (!RegExp(r"^(?=.*[0-9])(?=.*[!@#$%^&*(),.?\:{}|<>]).*$")
        .hasMatch(value)) {
      return 'Password must contain at least one number and one special character';
    }
    return null; // Indicates a valid password
  }

  String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Location is required';
    }
    return null; // Indicates a valid location
  }

  String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Gender is required';
    }
    return null; // Indicates a valid gender
  }

  String? validateBlood(String? value) {
    if (value == null || value.isEmpty) {
      return 'Blood is required';
    }
    return null; // Indicates a valid gender
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              backgroundColor: Colors.white,
              body: Form(
                key: _formkey,
                child: ListView(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10.w, 5.h, 0.w, 0.h),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera,
                                  color: Colors.black,
                                  size: 35,
                                ),
                                onPressed: () {
                                  _getImage(ImageSource.camera);
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10.w, 0.h, 0.w, 0),
                              child: Text(
                                'Camera',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10.w, 3.h, 0, 0),
                          child: Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: _image != null
                                  ? FileImage(_image!)
                                  : const NetworkImage(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAYLB3IWsTasUT1Kt1-UeUbzXQPQZDufxUkA&usqp=CAU')
                                      as ImageProvider<Object>?,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10.w, 5.h, 0.w, 0),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.browse_gallery,
                                  color: Colors.black,
                                  size: 35,
                                ),
                                onPressed: () {
                                  _getImage(ImageSource.gallery);
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10.w, 0.h, 0.w, 0),
                              child: Text(
                                'Gallery',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(5.w, 2.h, 2.w, 0),
                            child: Material(
                              elevation: 7.0, // Add shadow/elevation
                              borderRadius: BorderRadius.circular(
                                  10.0), // Add border radius
                              child: TextFormField(
                                controller: _fname,
                                decoration: InputDecoration(
                                  label: const Text('First Name'),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0), // Adjust padding
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(
                                        color: Colors.grey), // Border color
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(
                                        color: Colors
                                            .blue), // Border color when focused
                                  ),
                                  hintText: 'First Name',
                                ),
                                validator: _validateFirstName,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(1.w, 2.h, 5.w, 0),
                            child: Material(
                              elevation: 7.0, // Add shadow/elevation
                              borderRadius: BorderRadius.circular(
                                  10.0), // Add border radius
                              child: TextFormField(
                                controller: _lname,
                                decoration: InputDecoration(
                                  label: const Text('Last Name'),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0), // Adjust padding
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(
                                        color: Colors.grey), // Border color
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(
                                        color: Colors
                                            .blue), // Border color when focused
                                  ),
                                  hintText: 'Last Name',
                                ),
                                validator: _validateLastName,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
                        child: SizedBox(
                          height: 12.h,
                          child: IntlPhoneField(
                            controller: _phonenumber,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0.8, color: Colors.black),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                )),
                            initialCountryCode: 'AE',
                            onChanged: (phone) {
                              setState(() {
                                _phone = phone.toString();
                              });
                            },
                            validator: (phoneNumber) {
                              // ignore: unnecessary_null_comparison
                              _validatePhoneNumber(phoneNumber.toString());
                              // if (_phonenumber.text == null ||
                              //     _phonenumber.text.isEmpty) {
                              //   return 'Phone number is required';
                              // }
                              return null; // Return null for a valid input
                            },
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
                      child: Material(
                        elevation: 7.0, // Add shadow/elevation
                        borderRadius:
                            BorderRadius.circular(10.0), // Add border radius
                        child: TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                            label: const Text('Email'),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0), // Adjust padding
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors.grey), // Border color
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color:
                                      Colors.blue), // Border color when focused
                            ),
                            hintText: 'Email',
                          ),
                          validator: _validateEmail,
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
                          controller: _location,
                          decoration: InputDecoration(
                            label: const Text('Location'),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0), // Adjust padding
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors.grey), // Border color
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color:
                                      Colors.blue), // Border color when focused
                            ),
                            hintText: 'Location',
                          ),
                          validator: validateLocation,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(5.w, 2.h, 0.w, 0),
                              child: Material(
                                elevation: 7.0,
                                borderRadius: BorderRadius.circular(10.0),
                                child: DropdownButtonFormField(
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 13.0),
                                    labelText: "Blood Group",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.5),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0)),
                                  items: nomi1
                                      .map((e) => DropdownMenuItem(
                                            // ignore: sort_child_properties_last
                                            child: Text(e),
                                            value: e,
                                          ))
                                      .toList(),
                                  validator: validateBlood,
                                  onChanged: (v) {
                                    setState(() {
                                      selectedIndex1 = v!;
                                    });
                                  },
                                ),
                              )),
                        ),
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(3.w, 2.h, 5.w, 0),
                              child: Material(
                                elevation: 7.0,
                                borderRadius: BorderRadius.circular(10.0),
                                child: DropdownButtonFormField(
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 13.0),
                                    labelText: "Gender",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.5),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0)),
                                  items: nomi
                                      .map((e) => DropdownMenuItem(
                                            // ignore: sort_child_properties_last
                                            child: Text(e),
                                            value: e,
                                          ))
                                      .toList(),
                                  validator: validateGender,
                                  onChanged: (v) {
                                    setState(() {
                                      selectedIndex = v!;
                                    });
                                  },
                                ),
                              )),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(5.w, 2.h, 0, 0.0),
                            child: Material(
                              elevation: 7.0,
                              borderRadius: BorderRadius.circular(10.0),
                              child: TextFormField(
                                controller: _password,
                                obscureText:
                                    _obscureText, // Set to true to obscure text
                                decoration: InputDecoration(
                                  label: const Text('New'),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        const BorderSide(color: Colors.blue),
                                  ),
                                  hintText: 'New Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                  ),
                                ),
                                validator: _validatePassword,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(2.w, 2.h, 5.w, 0.0),
                            child: Material(
                              elevation: 7.0,
                              borderRadius: BorderRadius.circular(10.0),
                              child: TextFormField(
                                controller: _conpassword,
                                obscureText:
                                    _obscureText1, // Set to true to obscure text
                                decoration: InputDecoration(
                                  label: const Text('Confirm'),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        const BorderSide(color: Colors.blue),
                                  ),
                                  hintText: 'Confirm',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureText1
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText1 = !_obscureText1;
                                      });
                                    },
                                  ),
                                ),
                                validator: _validatePassword,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0),
                      child: Material(
                        elevation: 10.0,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_phonenumber.text.isNotEmpty) {
                              if (_password.text.toString() ==
                                  _conpassword.text.toString()) {
                                if (_formkey.currentState != null &&
                                    _formkey.currentState!.validate()) {
                                  String email = _email.text;
                                  // ignore: unused_local_variable, non_constant_identifier_names
                                  int Id = id;
                                  String image = _image!.path.toString();
                                  String fname = _fname.text;
                                  String lname = _lname.text;
                                  String number = _phonenumber.text;
                                  String location = _location.text;
                                  String blood = selectedIndex1;
                                  String gender = selectedIndex;
                                  String password = _password.text;
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return SimpleAuthentication(
                                            email: email,
                                            Id: id,
                                            image: image,
                                            fname: fname,
                                            lname: lname,
                                            number: number,
                                            location: location,
                                            blood: blood,
                                            gender: gender,
                                            password: password);
                                      },
                                      transitionDuration:
                                          const Duration(seconds: 1),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(10.0,
                                            0.0); // slide in from the right
                                        const end = Offset.zero;
                                        const curve = Curves.easeInOutQuart;

                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));
                                        var offsetAnimation =
                                            animation.drive(tween);

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                }
                              } else {
                                _showAlertDialog2(context);
                              }
                            } else {
                              _showAlertDialog4(context);
                            }
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              // ignore: prefer_const_constructors
                              EdgeInsets.symmetric(
                                  vertical: 13.5, horizontal: 0),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFDE0A1E)), // Change button color
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (showCircularProgressIndicator)
                                const SizedBox(
                                  height: 20.0, // Set your desired height here
                                  width: 20.0, // Set your desired width here
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                              if (!showCircularProgressIndicator)
                                Text(
                                  'Continue',
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
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(15.w, 1.h, 0, 0),
                            child: Text(
                              'Already have an acoount?',
                              style: TextStyle(
                                  fontSize: 12.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0.w, 1.h, 16.w, 0),
                            child: TextButton(
                              child: Text(
                                'Sign in',
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return const LoginScreen();
                                    },
                                    transitionDuration:
                                        const Duration(seconds: 1),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(
                                          10.0, 0.0); // slide in from the right
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOutQuart;

                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));
                                      var offsetAnimation =
                                          animation.drive(tween);

                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                            ))
                      ],
                    )
                  ],
                ),
              )),
        );
      },
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Please Fill all the fields'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the alert dialog
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialog1(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content:
              const Text('Email is already Exist Pleae add diffirent email'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the alert dialog
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialog2(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Please Enter Same Password:'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the alert dialog
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialog4(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Please must be enter Phone Number:'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the alert dialog
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
