// ignore_for_file: unused_element, prefer_final_fields, file_names

import 'dart:developer';
import 'dart:io';

import 'package:blood_donor/Screens/Authentication%20Screen/LoginScreen.dart';
import 'package:blood_donor/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

class SimpleSignup extends StatefulWidget {
  const SimpleSignup({super.key});

  @override
  State<SimpleSignup> createState() => _SimpleSignupState();
}

class _SimpleSignupState extends State<SimpleSignup> {
  List<String> nomi = ['Male', 'Female'];
  String selectedIndex = '';
  List<String> nomi1 = ['A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-', 'AB-'];
  String selectedIndex1 = '';
  String type = ''; // Default country code
  String mobileNumber = '';
  int id = 1;
  String picture = '';
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController _phonenumber = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _conpassword = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _fname = TextEditingController();

  TextEditingController _lname = TextEditingController();

  // ignore: unused_field
  late final _phone;
  bool _obscureText = false;
  bool _obscureText1 = false;
  int activeStep = 0;

  // Future<void> _getImage(ImageSource source) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: source);

  //   if (pickedFile != null) {
  //     final fileSize = await pickedFile.length();
  //     const maxFileSize = 1 * 1024 * 1024; // 1MB in bytes

  //     // if (fileSize > maxFileSize) {
  //     //   // File size exceeds 1MB, compress the image
  //     //   // final compressedFile = await _compressImage(File(pickedFile.path));
  //     //   // final compressedFileSize = await compressedFile.length();

  //     //   // if (compressedFileSize > maxFileSize) {
  //     //   //   _showFileSizeExceededMessage();
  //     //   // } else {
  //     //   //   setState(() {
  //     //   //     image = compressedFile as File?;
  //     //   //   });
  //     //   // }

  //     setState(() {
  //       image = File(pickedFile.path);
  //     });
  //   } else {
  //     print('No image selected.');
  //   }
  // }
  File? image;

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final fileSize = await File(pickedFile.path).length();
      const maxFileSize = 1 * 1024 * 1024; // 1MB in bytes

      if (fileSize > maxFileSize) {
        final compressedFile = await _compressImage(File(pickedFile.path));
        final compressedFileSize = await compressedFile.length();

        if (compressedFileSize > maxFileSize) {
          _showFileSizeExceededMessage();
        } else {
          setState(() {
            image = compressedFile;
          });
        }
      } else {
        setState(() {
          image = File(pickedFile.path);
        });
      }
    } else {
      print('No image selected.');
    }
  }

  Future<File> _compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = path.join(dir.absolute.path, 'temp.jpg');

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80,
    );

    while ((await result!.length()) > 1 * 1024 * 1024) {
      result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 70, // Adjust quality parameter to further reduce file size
      );
    }
    log(result.path);
    return File(result.path);
  }

  void _showFileSizeExceededMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File size exceeds 1MB.'),
      ),
    );
  }
  // Future<XFile> _compressImage(File file) async {
  //   final dir = await getTemporaryDirectory();
  //   final targetPath = path.join(dir.absolute.path, 'temp.jpg');

  //   var result = await FlutterImageCompress.compressAndGetFile(
  //     file.absolute.path,
  //     targetPath,
  //     quality: 80,
  //   );

  //   while ((await result!.length()) > 1 * 1024 * 1024) {
  //     result = await FlutterImageCompress.compressAndGetFile(
  //       file.absolute.path,
  //       targetPath,
  //       quality: 80, // Adjust quality parameter to further reduce file size
  //     );
  //   }

  //   return result;
  // }

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
    return Scaffold(
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
                          color: Colors.black45,
                          size: 30,
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
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.w, 3.h, 0, 0),
                  child: Center(
                    child: CircleAvatar(
                      radius: 50,
                      // ignore: unnecessary_null_comparison
                      backgroundImage: image != null
                          ? FileImage(image!)
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
                          Icons.browse_gallery_sharp,
                          color: Colors.black45,
                          size: 30,
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
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45),
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
                      elevation: 2.5,
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      child: TextFormField(
                        controller: _fname,
                        decoration: InputDecoration(
                          label: const Text(
                            'First Name',
                            style:
                                TextStyle(fontSize: 15, color: Colors.black45),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.black12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          // hintText: 'First Name',
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
                      elevation: 2.5, // Add shadow/elevation
                      borderRadius:
                          BorderRadius.circular(10.0), // Add border radius
                      child: TextFormField(
                        controller: _lname,
                        decoration: InputDecoration(
                          label: const Text(
                            'Last Name',
                            style:
                                TextStyle(fontSize: 15, color: Colors.black45),
                          ),
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
                                    Colors.white), // Border color when focused
                          ),
                          // hintText: 'Last Name',
                        ),
                        validator: _validateLastName,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(5.w, 2.4.h, 5.w, 0),
                child: SizedBox(
                  height: 12.h,
                  child: IntlPhoneField(
                    controller: _phonenumber,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle:
                            TextStyle(fontSize: 15, color: Colors.black45),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.8, color: Colors.black26),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        )),
                    initialCountryCode: 'PK',
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
                elevation: 2.5, // Add shadow/elevation
                borderRadius: BorderRadius.circular(10.0), // Add border radius
                child: TextFormField(
                  // onFieldSubmitted: (value) async {
                  //   bool reult = await checkEmail();
                  //   if (reult) {
                  //     // showDialogInfo('');
                  //   } else {
                  //     showDialogInfo(
                  //         'This Email is already Exist. Please try another email!');
                  //     _email.clear();
                  //   }
                  // },

                  controller: _email,
                  decoration: InputDecoration(
                    label: const Text(
                      'Email',
                      style: TextStyle(fontSize: 15, color: Colors.black45),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0), // Adjust padding
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.red), // Border color
                    ),
                    suffixIcon: SizedBox(
                      height: 1.h,
                      width: 25.w,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 1.h, 2.w, 1.h),
                        child: ElevatedButton(
                          onPressed: () async {
                            bool reult = await checkEmail();
                            if (reult) {
                              // showDialogInfo('');
                            } else {
                              showDialogInfo(
                                  'This Email is already Exist. Please try another email!');
                              _email.clear();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PRIMARY_COLOR,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                8.0,
                              ), // Set borderRadius to 0 for flat corners
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'verify',
                              style: TextStyle(
                                  fontSize: 10.sp, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                          color: Colors.white), // Border color when focused
                    ),
                    // hintText: 'Email',
                  ),
                  validator: _validateEmail,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 2.4.h, 5.w, 0),
              child: Material(
                elevation: 2.5, // Add shadow/elevation
                borderRadius: BorderRadius.circular(10.0), // Add border radius
                child: TextFormField(
                  controller: _location,
                  decoration: InputDecoration(
                    label: const Text(
                      'Location',
                      style: TextStyle(fontSize: 15, color: Colors.black45),
                    ),

                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0), // Adjust padding
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Colors.grey), // Border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                          color: Colors.white), // Border color when focused
                    ),
                    // hintText: 'Location',
                  ),
                  validator: validateLocation,
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
            Row(
              children: [
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 2.4.h, 0.w, 0),
                      child: Material(
                        elevation: 2.5,
                        borderRadius: BorderRadius.circular(10.0),
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 13.0),
                            labelText: "Blood Group",
                            labelStyle:
                                TextStyle(fontSize: 15, color: Colors.black45),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.5),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
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
                      padding: EdgeInsets.fromLTRB(3.w, 2.4.h, 5.w, 0),
                      child: Material(
                        elevation: 2.5,
                        borderRadius: BorderRadius.circular(10.0),
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 13.0),
                            labelText: "Gender",
                            labelStyle:
                                TextStyle(fontSize: 15, color: Colors.black45),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.5),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
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
                    padding: EdgeInsets.fromLTRB(5.w, 2.4.h, 0, 0.0),
                    child: Material(
                      elevation: 2.5,
                      borderRadius: BorderRadius.circular(10.0),
                      child: TextFormField(
                        controller: _password,
                        obscureText:
                            _obscureText, // Set to true to obscure text
                        decoration: InputDecoration(
                          label: const Text('New',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black45)),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          // hintText: 'New Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 22,
                              color: Colors.black45,
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
                    padding: EdgeInsets.fromLTRB(2.w, 2.4.h, 5.w, 0.0),
                    child: Material(
                      elevation: 2.5,
                      borderRadius: BorderRadius.circular(10.0),
                      child: TextFormField(
                        controller: _conpassword,
                        obscureText:
                            _obscureText1, // Set to true to obscure text
                        decoration: InputDecoration(
                          label: const Text(
                            'Confirm',
                            style:
                                TextStyle(fontSize: 15, color: Colors.black45),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          // hintText: 'Confirm',
                          suffixIcon: IconButton(
                            icon: Icon(
                                _obscureText1
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 22,
                                color: Colors.black45),
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
              padding: EdgeInsets.fromLTRB(5.w, 4.h, 5.w, 0),
              child: Material(
                elevation: 3.5,
                shadowColor: Colors.black,
                borderRadius: BorderRadius.circular(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (image != null) {
                      print("image is $image");
                      if (_phonenumber.text.isNotEmpty) {
                        if (_password.text.toString() ==
                            _conpassword.text.toString()) {
                          if (_formkey.currentState != null &&
                              _formkey.currentState!.validate()) {
                            // setState(() {
                            //   if (activeStep < 4) activeStep++;
                            // });
                          }
                        } else {
                          _showAlertDialog2(context);
                        }
                      } else {
                        _showAlertDialog4(context);
                      }
                    } else {
                      EasyLoading.showInfo("Must upload Picture");
                    }
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => IDCARDScanning()));
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      // ignore: prefer_const_constructors
                      EdgeInsets.symmetric(vertical: 13.5, horizontal: 0),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFDE0A1E)), // Change button color
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 12.sp, // Adjust the font size
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15.w, 0.h, 0, 0),
                  child: Text(
                    'Already have an account?',
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0.w, 0.h, 16.w, 0),
                    child: TextButton(
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return const LoginScreen();
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
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  showDialogInfo(String message) {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Disallows dismissing the dialog by tapping outside it
      builder: (BuildContext context) {
        final textTheme = Theme.of(context)
            .textTheme
            .apply(displayColor: Theme.of(context).colorScheme.onSurface);

        return CupertinoAlertDialog(
          // Dialog title with formatted text
          title: Text('Alert!',
              style: textTheme.titleLarge!.copyWith(
                  color: PRIMARY_COLOR,
                  letterSpacing: 0.1,
                  fontWeight: FontWeight.bold)),
          // Dialog content with formatted text
          content: Text('$message', style: textTheme.bodyMedium!),
          actions: <Widget>[
            // Button to continue with formatted text
            CupertinoDialogAction(
              child: Text('Continue',
                  style: textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      letterSpacing: 0.3)),
              onPressed: () {
                Navigator.of(context).pop(); // Dismisses the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> checkEmail() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      CollectionReference users = _firestore.collection('users');

      // Check if email exists in Firestore
      QuerySnapshot existingUsers =
          await users.where('email', isEqualTo: _email.text).get();

      if (existingUsers.docs.isNotEmpty) {
        // Email exists in Firestore users collection
        return false;
      } else {
        try {
          // Check if email exists in Firebase Authentication
          List<String> signInMethods =
              await _auth.fetchSignInMethodsForEmail(_email.text);

          if (signInMethods.isNotEmpty) {
            // Email exists in Firebase Authentication
            return false;
          } else {
            // Email does not exist in Firebase Authentication
            return true;
          }
        } catch (error) {
          // Handle error in checking Firebase Authentication
          print("Error in checking Firebase Authentication: $error");
          return false;
        }
      }
    } catch (error) {
      // Handle error in checking Firestore
      print("Error in checkEmail: $error");
      return false;
    }
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
