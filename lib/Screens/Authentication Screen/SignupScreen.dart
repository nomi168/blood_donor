// ignore_for_file: file_names, prefer_typing_uninitialized_variables, unrelated_type_equality_checks, prefer_final_fields, use_build_context_synchronously, non_constant_identifier_names

import 'dart:io';

import 'package:blood_donor/Provider/Page.dart';
import 'package:blood_donor/Screens/Authentication%20Screen/LoginScreen.dart';
import 'package:blood_donor/Screens/Main%20Screen/Dashoard/Dashboatd.dart';
import 'package:blood_donor/Screens/Main%20Screen/Feed%20Screen/Notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnic_scanner/cnic_scanner.dart';
import 'package:cnic_scanner/model/cnic_model.dart';
// import 'package:cnic_scanner/cnic_scanner.dart';
// import 'package:cnic_scanner/model/cnic_model.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../constants.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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

  ////////// OTP Screen
  TextEditingController email = TextEditingController();
  TextEditingController otp = TextEditingController();
  EmailOTP myauth = EmailOTP();
  bool isClicked = false;
  bool isClicked1 = false;
  bool result = false;
  bool otpresult = false;
  bool otpsend = false;
  bool hidescanning = false;

  /////////////// Card Scanning
  TextEditingController nameTEController = TextEditingController();
  TextEditingController cnicTEController = TextEditingController();
  TextEditingController dobTEController = TextEditingController();
  TextEditingController doiTEController = TextEditingController();
  TextEditingController doeTEController = TextEditingController();
  bool correctcnic = false;

//////////// Questions
  String Q1 = '';
  String Q2 = '';
  String Q3 = '';
  String Q4 = '';
  String Q5 = '';
  String Q6 = '';
  String type1 = '';
  bool flag = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool showCircularProgressIndicator = false;
  String token = '';
  String picture1 = '';
  String user_id = '';
  bool privacy_process = false;
  bool terms = false;

  NotificationServices notificationServices = NotificationServices();

  getNotificationToken() async {
    String token1 = await notificationServices.getDeviceToken();
    token = token1;
    setState(() {});
  }

  CnicModel _cnicModel = CnicModel();

  Future<void> scanCnic(ImageSource imageSource) async {
    /// you will need to pass one argument of "ImageSource" as shown here
    CnicModel cnicModel =
        await CnicScanner().scanImage(imageSource: imageSource);
    setState(() {
      _cnicModel = cnicModel;
      nameTEController.text = _cnicModel.cnicHolderName;
      cnicTEController.text = _cnicModel.cnicNumber;
      dobTEController.text = _cnicModel.cnicHolderDateOfBirth;
      doiTEController.text = _cnicModel.cnicIssueDate;
      doeTEController.text = _cnicModel.cnicExpiryDate;
      correctcnic = true;
    });
  }

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
    // log(result.path);
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
    if (value == null || value.trim().isEmpty) {
      return 'First Name is required';
    } else if (!RegExp(r"^[a-zA-Z ]+$").hasMatch(value)) {
      return 'Only letters and spaces are allowed';
    } else if (value
        .split(' ')
        .any((word) => word.isNotEmpty && word[0].toUpperCase() != word[0])) {
      return 'Each word must start with a capital letter';
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Last Name is required';
    } else if (!RegExp(r"^[a-zA-Z ]+$").hasMatch(value)) {
      return 'Only letters and spaces are allowed';
    } else if (value
        .split(' ')
        .any((word) => word.isNotEmpty && word[0].toUpperCase() != word[0])) {
      return 'Each word must start with a capital letter';
    }
    return null;
  }

  // ignore: unused_element
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

  // String? imageValidationResult =
  //     validateImage(_image!.path.toString() as File?);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: Colors.white,
                  // borderRadius: BorderRadius.vertical(
                  //   bottom: Radius.circular(16),
                  // ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: Offset(0, 4), // Shadow position
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    EasyStepper(
                      activeStep: activeStep,
                      activeStepTextColor: Colors.black87,
                      finishedStepTextColor: Colors.black87,
                      internalPadding: 10,
                      showLoadingAnimation: true,
                      stepRadius: 12,
                      showStepBorder: false,
                      steps: [
                        EasyStep(
                          customStep: _buildStepIcon(
                              isActive: activeStep >= 0,
                              isCompleted: activeStep > 0),
                          title: 'Step 1',
                        ),
                        EasyStep(
                          customStep: _buildStepIcon(
                              isActive: activeStep >= 1,
                              isCompleted: activeStep > 1),
                          title: 'Step 2',
                        ),
                        EasyStep(
                          customStep: _buildStepIcon(
                              isActive: activeStep >= 2,
                              isCompleted: activeStep > 2),
                          title: 'Step 3',
                        ),
                        EasyStep(
                          customStep: _buildStepIcon(
                              isActive: activeStep >= 3,
                              isCompleted: activeStep > 3),
                          title: 'Step 4',
                        ),
                        // EasyStep(
                        //   customStep: _buildStepIcon(
                        //       isActive: activeStep >= 4,
                        //       isCompleted: activeStep > 4),
                        //   title: 'Step 5',
                        // ),
                      ],
                      // onStepReached: (index) =>
                      //     setState(() => activeStep = index),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Visibility(
                        visible: activeStep == 0,
                        child: Expanded(
                          child: Form(
                            key: _formkey,
                            child: ListView(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10.w, 5.h, 0.w, 0.h),
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
                                          padding: EdgeInsets.fromLTRB(
                                              10.w, 0.h, 0.w, 0),
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
                                      padding:
                                          EdgeInsets.fromLTRB(10.w, 3.h, 0, 0),
                                      child: Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          padding: EdgeInsets.all(1),
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
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10.w, 5.h, 0.w, 0),
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
                                          padding: EdgeInsets.fromLTRB(
                                              10.w, 0.h, 0.w, 0),
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
                                        padding: EdgeInsets.fromLTRB(
                                            5.w, 2.h, 2.w, 0),
                                        child: Material(
                                          elevation: 2.5,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white,
                                          child: TextFormField(
                                            controller: _fname,
                                            decoration: InputDecoration(
                                              label: const Text(
                                                'First Name',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black45),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.black12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
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
                                        padding: EdgeInsets.fromLTRB(
                                            1.w, 2.h, 5.w, 0),
                                        child: Material(
                                          color: Colors.white,
                                          elevation:
                                              2.5, // Add shadow/elevation
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Add border radius
                                          child: TextFormField(
                                            controller: _lname,
                                            decoration: InputDecoration(
                                              label: const Text(
                                                'Last Name',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black45),
                                              ),
                                              contentPadding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal:
                                                      16.0), // Adjust padding
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                borderSide: const BorderSide(
                                                    color: Colors
                                                        .grey), // Border color
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                borderSide: const BorderSide(
                                                    color: Colors
                                                        .white), // Border color when focused
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
                                  padding:
                                      EdgeInsets.fromLTRB(5.w, 2.4.h, 5.w, 0),
                                  child: SizedBox(
                                    height: 12.h,
                                    child: IntlPhoneField(
                                      controller: _phonenumber,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'Phone Number',
                                        labelStyle: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black45),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 0.8,
                                              color: Colors.black26),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      initialCountryCode:
                                          'PK', // Set the default country code
                                      onChanged: (phone) {
                                        setState(() {
                                          _phone = phone
                                              .completeNumber; // Store the full number with country code
                                        });
                                      },
                                      onCountryChanged: (country) {
                                        // Update the text field with the new country code
                                        setState(() {
                                          _phonenumber.text =
                                              '+${country.dialCode}';
                                        });
                                      },
                                      validator: (phoneNumber) {
                                        if (phoneNumber == null ||
                                            phoneNumber.number.isEmpty) {
                                          return 'Phone number is required';
                                        }

                                        return null; // Return null for valid input
                                      },
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 2.5, // Add shadow/elevation
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Add border radius
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
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black45),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal:
                                                    16.0), // Adjust padding
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: BorderSide(
                                              color:
                                                  Colors.red), // Border color
                                        ),
                                        // suffixIcon: SizedBox(
                                        //   height: 1.h,
                                        //   width: 25.w,
                                        //   child: Padding(
                                        //     padding: EdgeInsets.fromLTRB(
                                        //         0, 1.h, 2.w, 1.h),
                                        //     child: ElevatedButton(
                                        //       onPressed: () async {},
                                        //       style: ElevatedButton.styleFrom(
                                        //         backgroundColor: PRIMARY_COLOR,
                                        //         elevation: 0,
                                        //         shape: RoundedRectangleBorder(
                                        //           borderRadius:
                                        //               BorderRadius.circular(
                                        //             8.0,
                                        //           ),
                                        //         ),
                                        //       ),
                                        //       child: Center(
                                        //         child: Text(
                                        //           'verify',
                                        //           style: TextStyle(
                                        //               fontSize: 10.sp,
                                        //               color: Colors.white),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(
                                              color: Colors
                                                  .white), // Border color when focused
                                        ),
                                        // hintText: 'Email',
                                      ),
                                      validator: _validateEmail,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(5.w, 2.4.h, 5.w, 0),
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 2.5, // Add shadow/elevation
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Add border radius
                                    child: TextFormField(
                                      controller: _location,
                                      decoration: InputDecoration(
                                        label: const Text(
                                          'Location',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black45),
                                        ),

                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal:
                                                    16.0), // Adjust padding
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(
                                              color:
                                                  Colors.grey), // Border color
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(
                                              color: Colors
                                                  .white), // Border color when focused
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
                                    style: TextStyle(
                                        fontSize: 11, color: PRIMARY_COLOR),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              5.w, 2.4.h, 0.w, 0),
                                          child: Material(
                                            color: Colors.white,
                                            elevation: 2.5,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: DropdownButtonFormField(
                                              decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 13.0),
                                                labelText: "Blood Group",
                                                labelStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black45),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 2.5),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                ),
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
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
                                          padding: EdgeInsets.fromLTRB(
                                              3.w, 2.4.h, 5.w, 0),
                                          child: Material(
                                            color: Colors.white,
                                            elevation: 2.5,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: DropdownButtonFormField(
                                              decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 13.0),
                                                labelText: "Gender",
                                                labelStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black45),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 2.5),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                ),
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
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
                                        padding: EdgeInsets.fromLTRB(
                                            5.w, 2.4.h, 0, 0.0),
                                        child: Material(
                                          color: Colors.white,
                                          elevation: 2.5,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: TextFormField(
                                            controller: _password,
                                            obscureText:
                                                _obscureText, // Set to true to obscure text
                                            decoration: InputDecoration(
                                              label: const Text('New',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black45)),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
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
                                                    _obscureText =
                                                        !_obscureText;
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
                                        padding: EdgeInsets.fromLTRB(
                                            2.w, 2.4.h, 5.w, 0.0),
                                        child: Material(
                                          color: Colors.white,
                                          elevation: 2.5,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: TextFormField(
                                            controller: _conpassword,
                                            obscureText:
                                                _obscureText1, // Set to true to obscure text
                                            decoration: InputDecoration(
                                              label: const Text(
                                                'Confirm',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black45),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
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
                                                    _obscureText1 =
                                                        !_obscureText1;
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
                                // Padding(
                                //   padding:
                                //       EdgeInsets.fromLTRB(5.w, 4.h, 5.w, 0),
                                //   child: Material(
                                //     elevation: 3.5,
                                //     shadowColor: Colors.black,
                                //     borderRadius: BorderRadius.circular(10.0),
                                //     child: ElevatedButton(
                                //       onPressed: () {
                                //         if (image != null) {
                                //           print("image is $image");
                                //           if (_phonenumber.text.isNotEmpty) {
                                //             if (_password.text.toString() ==
                                //                 _conpassword.text.toString()) {
                                //               if (_formkey.currentState !=
                                //                       null &&
                                //                   _formkey.currentState!
                                //                       .validate()) {
                                //                 // setState(() {
                                //                 //   if (activeStep < 4) activeStep++;
                                //                 // });
                                //               }
                                //             } else {
                                //               _showAlertDialog2(context);
                                //             }
                                //           } else {
                                //             _showAlertDialog4(context);
                                //           }
                                //         } else {
                                //           EasyLoading.showInfo(
                                //               "Must upload Picture");
                                //         }
                                //         // Navigator.push(
                                //         //     context,
                                //         //     MaterialPageRoute(
                                //         //         builder: (context) => IDCARDScanning()));
                                //       },
                                //       style: ButtonStyle(
                                //         shape: MaterialStateProperty.all<
                                //             RoundedRectangleBorder>(
                                //           RoundedRectangleBorder(
                                //             borderRadius:
                                //                 BorderRadius.circular(10.0),
                                //           ),
                                //         ),
                                //         padding: MaterialStateProperty.all<
                                //             EdgeInsetsGeometry>(
                                //           // ignore: prefer_const_constructors
                                //           EdgeInsets.symmetric(
                                //               vertical: 13.5, horizontal: 0),
                                //         ),
                                //         backgroundColor: MaterialStateProperty
                                //             .all<Color>(const Color(
                                //                 0xFFDE0A1E)), // Change button color
                                //       ),
                                //       child: Text(
                                //         'Sign Up',
                                //         style: TextStyle(
                                //           fontSize:
                                //               12.sp, // Adjust the font size
                                //           fontWeight: FontWeight.bold,
                                //           color: Colors.white,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(15.w, 0.h, 0, 0),
                                      child: Text(
                                        'Already have an account?',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0.w, 0.h, 16.w, 0),
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
                                                pageBuilder: (context,
                                                    animation,
                                                    secondaryAnimation) {
                                                  return const LoginScreen();
                                                },
                                                transitionDuration:
                                                    const Duration(seconds: 1),
                                                transitionsBuilder: (context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child) {
                                                  const begin = Offset(10.0,
                                                      0.0); // slide in from the right
                                                  const end = Offset.zero;
                                                  const curve =
                                                      Curves.easeInOutQuart;

                                                  var tween = Tween(
                                                          begin: begin,
                                                          end: end)
                                                      .chain(CurveTween(
                                                          curve: curve));
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
                          ),
                        )),
                    // Visibility(
                    //   visible: activeStep == 1,
                    //   child: Expanded(
                    //     child: Builder(
                    //       builder: (context) {
                    //         // Declare variables here
                    //         String email = _email.text.trim();
                    //         int id = 0; // Replace this with the actual id value
                    //         String iimage = image?.path.toString() ?? '';
                    //         String fname = _fname.text.trim();
                    //         String lname = _lname.text.trim();
                    //         String number = '0${_phonenumber.text.trim()}';
                    //         String location = _location.text.trim();
                    //         String blood = selectedIndex1;
                    //         String gender = selectedIndex;
                    //         String password = _password.text.trim();

                    //         // Return the child widget
                    //         return OTPSignup(
                    //           email: email,
                    //           Id: id,
                    //           image: iimage,
                    //           fname: fname,
                    //           lname: lname,
                    //           number: number,
                    //           location: location,
                    //           blood: blood,
                    //           gender: gender,
                    //           password: password,
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // ),
                    // Visibility(
                    //   visible: activeStep == 1,
                    //   child: Expanded(
                    //     child: SingleChildScrollView(
                    //       child: Column(
                    //         children: [
                    //           Padding(
                    //             padding: EdgeInsets.fromLTRB(0.w, 5.h, 0.w, 0),
                    //             child: Center(
                    //               child: Text(
                    //                 'Verification Code',
                    //                 style: TextStyle(
                    //                     fontSize: 22.sp,
                    //                     fontWeight: FontWeight.bold),
                    //               ),
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 0),
                    //             child: Center(
                    //               child: Text(
                    //                 'We will send you a verification code',
                    //                 style: TextStyle(
                    //                     fontSize: 12.sp,
                    //                     fontWeight: FontWeight.bold,
                    //                     color: Colors.black54),
                    //               ),
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 0),
                    //             child: Center(
                    //               child: Text(
                    //                 'on your email',
                    //                 style: TextStyle(
                    //                     fontSize: 12.sp,
                    //                     fontWeight: FontWeight.bold,
                    //                     color: Colors.black54),
                    //               ),
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 0),
                    //             child: Material(
                    //               color: Colors.white,
                    //               elevation: 7.0, // Add shadow/elevation
                    //               borderRadius: BorderRadius.circular(
                    //                   10.0), // Add border radius
                    //               child: TextFormField(
                    //                 controller: _email,
                    //                 readOnly: false,
                    //                 decoration: InputDecoration(
                    //                   label: const Text('Email'),
                    //                   contentPadding:
                    //                       const EdgeInsets.symmetric(
                    //                           horizontal:
                    //                               16.0), // Adjust padding
                    //                   border: OutlineInputBorder(
                    //                     borderRadius:
                    //                         BorderRadius.circular(8.0),
                    //                     borderSide: const BorderSide(
                    //                         color: Colors.grey), // Border color
                    //                   ),
                    //                   focusedBorder: OutlineInputBorder(
                    //                     borderRadius:
                    //                         BorderRadius.circular(8.0),
                    //                     borderSide: const BorderSide(
                    //                         color: Colors
                    //                             .blue), // Border color when focused
                    //                   ),
                    //                   hintText: 'Enter Email',
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: EdgeInsets.fromLTRB(60.w, 0.h, 5.w, 0),
                    //             child: Center(
                    //                 child: TextButton(
                    //               // ignore: prefer_const_constructors
                    //               child: Text(
                    //                 'Send OTP',
                    //                 style: TextStyle(
                    //                     fontWeight: FontWeight.bold,
                    //                     fontSize: 13.sp,
                    //                     color: isClicked
                    //                         ? Colors.red
                    //                         : Colors.blue,
                    //                     decoration: TextDecoration.underline),
                    //               ),
                    //               onPressed: () async {
                    //                 setState(() {
                    //                   isClicked = true;
                    //                 });

                    //                 myauth.setConfig(
                    //                     appEmail: "me@rohitchouhan.com",
                    //                     appName: "Email OTP",
                    //                     userEmail: "noumansaeed171@gmail.com",
                    //                     otpLength: 4,
                    //                     otpType: OTPType.digitsOnly);
                    //                 if (await myauth.sendOTP() == true) {
                    //                   ScaffoldMessenger.of(context)
                    //                       .showSnackBar(const SnackBar(
                    //                     content: Text("OTP has been sent"),
                    //                   ));
                    //                   setState(() {
                    //                     otpsend = true;
                    //                   });
                    //                 } else {
                    //                   ScaffoldMessenger.of(context)
                    //                       .showSnackBar(const SnackBar(
                    //                     content: Text("Oops, OTP send failed"),
                    //                   ));
                    //                 }
                    //               },
                    //             )),
                    //           ),
                    //           Padding(
                    //             padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
                    //             child: Material(
                    //               color: Colors.white,
                    //               elevation: 7.0, // Add shadow/elevation
                    //               borderRadius: BorderRadius.circular(
                    //                   10.0), // Add border radius
                    //               child: TextFormField(
                    //                 controller: otp,
                    //                 keyboardType: TextInputType.number,
                    //                 decoration: InputDecoration(
                    //                   label: const Text('OTP'),
                    //                   contentPadding:
                    //                       const EdgeInsets.symmetric(
                    //                           horizontal:
                    //                               16.0), // Adjust padding
                    //                   border: OutlineInputBorder(
                    //                     borderRadius:
                    //                         BorderRadius.circular(8.0),
                    //                     borderSide: const BorderSide(
                    //                         color: Colors.grey), // Border color
                    //                   ),
                    //                   focusedBorder: OutlineInputBorder(
                    //                     borderRadius:
                    //                         BorderRadius.circular(8.0),
                    //                     borderSide: const BorderSide(
                    //                         color: Colors
                    //                             .blue), // Border color when focused
                    //                   ),
                    //                   hintText: 'Enter OTP',
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
                    //             child: Center(
                    //               child: Text(
                    //                 'Donot recieve code?',
                    //                 style: TextStyle(
                    //                     fontSize: 12.sp,
                    //                     fontWeight: FontWeight.bold,
                    //                     color: Colors.black54),
                    //               ),
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: EdgeInsets.fromLTRB(5.w, 0.h, 5.w, 0),
                    //             child: Center(
                    //                 child: TextButton(
                    //               // ignore: prefer_const_constructors
                    //               child: Text(
                    //                 'Resend OTP',
                    //                 style: TextStyle(
                    //                     fontWeight: FontWeight.bold,
                    //                     fontSize: 13.sp,
                    //                     color: isClicked1
                    //                         ? Colors.red
                    //                         : Colors.blue,
                    //                     decoration: TextDecoration.underline),
                    //               ),
                    //               onPressed: () async {
                    //                 setState(() {
                    //                   isClicked1 = true;
                    //                 });
                    //                 myauth.setConfig(
                    //                     appEmail: "me@rohitchouhan.com",
                    //                     appName: "Email OTP",
                    //                     userEmail: _email.text,
                    //                     otpLength: 6,
                    //                     otpType: OTPType.digitsOnly);
                    //                 if (await myauth.sendOTP() == true) {
                    //                   ScaffoldMessenger.of(context)
                    //                       .showSnackBar(const SnackBar(
                    //                     content: Text("OTP has been sent"),
                    //                   ));
                    //                 } else {
                    //                   ScaffoldMessenger.of(context)
                    //                       .showSnackBar(const SnackBar(
                    //                     content: Text("Oops, OTP send failed"),
                    //                   ));
                    //                 }
                    //               },
                    //             )),
                    //           ),
                    //           // Padding(
                    //           //   padding: EdgeInsets.fromLTRB(5.w, 17.h, 5.w, 0),
                    //           //   child: Material(
                    //           //     elevation: 10.0,
                    //           //     shadowColor: Colors.black,
                    //           //     borderRadius: BorderRadius.circular(10.0),
                    //           //     child: ElevatedButton(
                    //           //       onPressed: () async {
                    //           //         if (await myauth.verifyOTP(otp: otp.text) ==
                    //           //             true) {
                    //           //           ScaffoldMessenger.of(context)
                    //           //               .showSnackBar(const SnackBar(
                    //           //             content: Text("OTP is verified"),
                    //           //           ));
                    //           //           setState(() {
                    //           //             otpresult = true;
                    //           //           });

                    //           //           // String email = widget.email;
                    //           //           // int id = widget.Id;
                    //           //           // String image = widget.image;
                    //           //           // String fname = widget.fname;
                    //           //           // String lname = widget.lname;

                    //           //           // String number = widget.number;
                    //           //           // String location = widget.location;
                    //           //           // String blood = widget.blood;
                    //           //           // String gender = widget.gender;
                    //           //           // String password = widget.password;
                    //           //           // Navigator.push(
                    //           //           //   context,
                    //           //           //   PageRouteBuilder(
                    //           //           //     pageBuilder: (context, animation, secondaryAnimation) {
                    //           //           //       return QuestionsScreen(
                    //           //           //           id: id,
                    //           //           //           image: image,
                    //           //           //           fname: fname,
                    //           //           //           lname: lname,
                    //           //           //           number: number,
                    //           //           //           email: email,
                    //           //           //           location: location,
                    //           //           //           blood: blood,
                    //           //           //           gender: gender,
                    //           //           //           password: password);
                    //           //           //     },
                    //           //           //     transitionDuration: const Duration(seconds: 1),
                    //           //           //     transitionsBuilder:
                    //           //           //         (context, animation, secondaryAnimation, child) {
                    //           //           //       const begin =
                    //           //           //           Offset(10.0, 0.0); // slide in from the right
                    //           //           //       const end = Offset.zero;
                    //           //           //       const curve = Curves.easeInOutQuart;

                    //           //           //       var tween = Tween(begin: begin, end: end)
                    //           //           //           .chain(CurveTween(curve: curve));
                    //           //           //       var offsetAnimation = animation.drive(tween);

                    //           //           //       return SlideTransition(
                    //           //           //         position: offsetAnimation,
                    //           //           //         child: child,
                    //           //           //       );
                    //           //           //     },
                    //           //           //   ),
                    //           //           // );
                    //           //         } else {
                    //           //           _showAlertDialog2(context);
                    //           //         }
                    //           //       },
                    //           //       style: ButtonStyle(
                    //           //         shape: MaterialStateProperty.all<
                    //           //             RoundedRectangleBorder>(
                    //           //           RoundedRectangleBorder(
                    //           //             borderRadius:
                    //           //                 BorderRadius.circular(10.0),
                    //           //           ),
                    //           //         ),
                    //           //         padding: MaterialStateProperty.all<
                    //           //             EdgeInsetsGeometry>(
                    //           //           // ignore: prefer_const_constructors
                    //           //           EdgeInsets.symmetric(
                    //           //               vertical: 13.5, horizontal: 35.w),
                    //           //         ),
                    //           //         backgroundColor: MaterialStateProperty
                    //           //             .all<Color>(const Color(
                    //           //                 0xFFDE0A1E)), // Change button color
                    //           //       ),
                    //           //       child: Text(
                    //           //         'Continue',
                    //           //         style: TextStyle(
                    //           //           fontSize: 12.sp, // Adjust the font size
                    //           //           fontWeight: FontWeight.bold,
                    //           //           color: Colors.white,
                    //           //         ),
                    //           //       ),
                    //           //     ),
                    //           //   ),
                    //           // ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    // Visibility(
                    //   visible: activeStep == 2,
                    //   child: Expanded(
                    //     child: Builder(
                    //       builder: (context) {
                    //         // String email = _email.text.trim();
                    //         // int id = 0;
                    //         // String iimage = image?.path.toString() ?? '';
                    //         // String fname = _fname.text.trim();
                    //         // String lname = _lname.text.trim();
                    //         // String number = '0${_phonenumber.text.trim()}';
                    //         // String location = _location.text.trim();
                    //         // String blood = selectedIndex1;
                    //         // String gender = selectedIndex;
                    //         // String password = _password.text.trim();

                    //         return IDCARDScanning();
                    //       },
                    //     ),
                    //   ),
                    // ),
                    Visibility(
                      visible: activeStep == 1,
                      child: Expanded(
                          child: SingleChildScrollView(
                        child: Column(children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0.w, 2.h, 0, 0),
                              child: Text(
                                'Verification Process',
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          SvgPicture.asset(
                            height: 30.h,
                            width: double.infinity,
                            'images/svg/Layer_1.svg',
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Setting Up your\nAccount',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13.sp, fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              'We are analyzing your account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 9.sp, fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          _customRow(1, 'Email verified', showIcon: true),
                          SizedBox(
                            height: 3.h,
                          ),
                          _customRow(2, 'Checking up your CNIC'),
                          // SizedBox(
                          //   height: 3.h,
                          // ),
                          // _customRow(3, 'Verifying your address'),
                          SizedBox(height: 3.h),
                          // Container(
                          //   width: double.infinity,
                          //   margin: EdgeInsets.fromLTRB(5.w, 4.h, 5.w, 0),
                          //   child: Material(
                          //     elevation: 3.5,
                          //     shadowColor: Colors.black,
                          //     borderRadius: BorderRadius.circular(10.0),
                          //     child: ElevatedButton(
                          //       onPressed: () {

                          //       },
                          //       style: ButtonStyle(
                          //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          //           RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(10.0),
                          //           ),
                          //         ),
                          //         padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          //           // ignore: prefer_const_constructors
                          //           EdgeInsets.symmetric(vertical: 13.5, horizontal: 0),
                          //         ),
                          //         backgroundColor: MaterialStateProperty.all<Color>(
                          //             const Color(0xFFDE0A1E)), // Change button color
                          //       ),
                          //       child: Text(
                          //         'Verify',
                          //         style: TextStyle(
                          //           fontSize: 12.sp, // Adjust the font size
                          //           fontWeight: FontWeight.bold,
                          //           color: Colors.white,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ]),
                      )),
                    ),
                    Visibility(
                      visible: activeStep == 2,
                      child: Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 0, bottom: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text('Enter ID Card Details',
                                    style: TextStyle(
                                        color: Color(kDarkGreyColor),
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Center(
                                child: Text(
                                    'To verify your Account, please enter your CNIC details.',
                                    style: TextStyle(
                                        color: Color(kLightGreyColor),
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w500)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                child: ListView(
                                  padding: const EdgeInsets.all(0),
                                  shrinkWrap: true,
                                  children: [
                                    _dataField(
                                        text: 'Name',
                                        textEditingController:
                                            nameTEController),
                                    _cnicField(
                                        textEditingController:
                                            cnicTEController),
                                    _dataField(
                                        text: 'Date of Birth',
                                        textEditingController: dobTEController),
                                    _dataField(
                                        text: 'Date of Card Issue',
                                        textEditingController: doiTEController),
                                    _dataField(
                                        text: 'Date of Card Expire',
                                        textEditingController: doeTEController),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    _getScanCNICBtn(),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    // _submitButton(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: activeStep == 3,
                      child: Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(5.w, 2.h, 0, 0),
                                child: Text(
                                  'Questionnaires',
                                  style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 0),
                                child: Text(
                                  'Fill up the following Questionnaires and become a donor',
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 0),
                                child: Material(
                                  color: Colors.white,
                                  elevation: 5,
                                  shadowColor: Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    height: 10.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 1,
                                      ),
                                    ),
                                    child: Stack(children: [
                                      Padding(
                                        // ignore: prefer_const_constructors
                                        padding: EdgeInsets.fromLTRB(
                                            5.w, 1.h, 37.w, 0),
                                        child: Text(
                                          'Do you have diabetes?',
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                            // ignore: prefer_const_constructors
                                            padding: EdgeInsets.fromLTRB(
                                                0.w, 3.h, 0.w, 0.h),
                                            child: RadioListTile<String>(
                                              title: const Text('Yes'),
                                              value: 'Yes',
                                              activeColor: PRIMARY_COLOR,
                                              groupValue: Q1,
                                              onChanged: (value) {
                                                setState(() {
                                                  Q1 = value!;
                                                  flag = true;
                                                });
                                              },
                                            ),
                                          )),
                                          Expanded(
                                              child: Padding(
                                            // ignore: prefer_const_constructors
                                            padding: EdgeInsets.fromLTRB(
                                                0.w, 3.h, 0.w, 0.h),
                                            child: RadioListTile<String>(
                                              title: const Text('No'),
                                              value: 'No',
                                              activeColor: PRIMARY_COLOR,
                                              groupValue: Q1,
                                              onChanged: (value) {
                                                setState(() {
                                                  Q1 = value!;
                                                });
                                              },
                                            ),
                                          )),
                                        ],
                                      )
                                    ]),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 0),
                                child: Material(
                                  color: Colors.white,
                                  elevation: 5,
                                  shadowColor: Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    height: 12.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 1,
                                      ),
                                    ),
                                    child: Stack(children: [
                                      Padding(
                                        // ignore: prefer_const_constructors
                                        padding: EdgeInsets.fromLTRB(
                                            5.w, 1.h, 0.w, 0),
                                        child: Text(
                                          'Have you ever had problems with your heart or lungs?',
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                            // ignore: prefer_const_constructors
                                            padding: EdgeInsets.fromLTRB(
                                                0.w, 5.h, 0.w, 0.h),
                                            child: RadioListTile<String>(
                                              title: const Text('Yes'),
                                              value: 'Yes',
                                              activeColor: PRIMARY_COLOR,
                                              groupValue: Q2,
                                              onChanged: (value) {
                                                setState(() {
                                                  Q2 = value!;
                                                  flag = true;
                                                });
                                              },
                                            ),
                                          )),
                                          Expanded(
                                              child: Padding(
                                            // ignore: prefer_const_constructors
                                            padding: EdgeInsets.fromLTRB(
                                                0.w, 5.h, 10.w, 0),
                                            child: RadioListTile<String>(
                                              title: const Text('No'),
                                              value: 'No',
                                              activeColor: PRIMARY_COLOR,
                                              groupValue: Q2,
                                              onChanged: (value) {
                                                setState(() {
                                                  Q2 = value!;
                                                });
                                              },
                                            ),
                                          )),
                                        ],
                                      )
                                    ]),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 0),
                                child: Material(
                                  color: Colors.white,
                                  elevation: 5,
                                  shadowColor: Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    height: 11.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 1,
                                      ),
                                    ),
                                    child: Stack(children: [
                                      Padding(
                                        // ignore: prefer_const_constructors
                                        padding: EdgeInsets.fromLTRB(
                                            5.w, 1.h, 0.w, 0),
                                        child: Text(
                                          'In the last 28 days do you have had COVID-19?',
                                          style: TextStyle(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                            // ignore: prefer_const_constructors
                                            padding: EdgeInsets.fromLTRB(
                                                0.w, 3.h, 0.w, 1.h),
                                            child: RadioListTile<String>(
                                              title: const Text('Yes'),
                                              value: 'Yes',
                                              activeColor: PRIMARY_COLOR,
                                              groupValue: Q3,
                                              onChanged: (value) {
                                                setState(() {
                                                  Q3 = value!;
                                                });
                                              },
                                            ),
                                          )),
                                          Expanded(
                                              child: Padding(
                                            // ignore: prefer_const_constructors
                                            padding: EdgeInsets.fromLTRB(
                                                0.w, 3.h, 10.w, 1.h),
                                            child: RadioListTile<String>(
                                              title: const Text('No'),
                                              value: 'No',
                                              activeColor: PRIMARY_COLOR,
                                              groupValue: Q3,
                                              onChanged: (value) {
                                                setState(() {
                                                  Q3 = value!;
                                                });
                                              },
                                            ),
                                          )),
                                        ],
                                      )
                                    ]),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 0),
                                child: Material(
                                  color: Colors.white,
                                  elevation: 5,
                                  shadowColor: Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    height: 12.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 1,
                                      ),
                                    ),
                                    child: Stack(children: [
                                      Padding(
                                        // ignore: prefer_const_constructors
                                        padding: EdgeInsets.fromLTRB(
                                            5.w, 1.h, 0.w, 0),
                                        child: Text(
                                          'Have you ever had a positive test for the HIV/AIDS virus?',
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                            // ignore: prefer_const_constructors
                                            padding: EdgeInsets.fromLTRB(
                                                0.w, 5.h, 0.w, 1.h),
                                            child: RadioListTile<String>(
                                              title: const Text('Yes'),
                                              value: 'Yes',
                                              activeColor: PRIMARY_COLOR,
                                              groupValue: Q4,
                                              onChanged: (value) {
                                                setState(() {
                                                  Q4 = value!;
                                                  flag = true;
                                                });
                                              },
                                            ),
                                          )),
                                          Expanded(
                                              child: Padding(
                                            // ignore: prefer_const_constructors
                                            padding: EdgeInsets.fromLTRB(
                                                0.w, 5.h, 10.w, 1.h),
                                            child: RadioListTile<String>(
                                              title: const Text('No'),
                                              value: 'No',
                                              activeColor: PRIMARY_COLOR,
                                              groupValue: Q4,
                                              onChanged: (value) {
                                                setState(() {
                                                  Q4 = value!;
                                                });
                                              },
                                            ),
                                          )),
                                        ],
                                      )
                                    ]),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 0),
                                child: Material(
                                  color: Colors.white,
                                  elevation: 5,
                                  shadowColor: Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    height: 9.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 1,
                                      ),
                                    ),
                                    child: Stack(children: [
                                      Padding(
                                        // ignore: prefer_const_constructors
                                        padding: EdgeInsets.fromLTRB(
                                            5.w, 1.h, 0.w, 0),
                                        child: Text(
                                          'Have you ever had cancer?',
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                            // ignore: prefer_const_constructors
                                            padding: EdgeInsets.fromLTRB(
                                                1.w, 2.5.h, 0.w, 1.h),
                                            child: RadioListTile<String>(
                                              title: const Text('Yes'),
                                              value: 'Yes',
                                              groupValue: Q5,
                                              activeColor: PRIMARY_COLOR,
                                              onChanged: (value) {
                                                setState(() {
                                                  Q5 = value!;
                                                  flag = true;
                                                });
                                              },
                                            ),
                                          )),
                                          Expanded(
                                              child: Padding(
                                            // ignore: prefer_const_constructors
                                            padding: EdgeInsets.fromLTRB(
                                                0.w, 2.5.h, 10.w, 1.h),
                                            child: RadioListTile<String>(
                                              title: const Text('No'),
                                              value: 'No',
                                              groupValue: Q5,
                                              activeColor: PRIMARY_COLOR,
                                              onChanged: (value) {
                                                setState(() {
                                                  Q5 = value!;
                                                });
                                              },
                                            ),
                                          )),
                                        ],
                                      )
                                    ]),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 0),
                                child: Material(
                                  color: Colors.white,
                                  elevation: 5,
                                  shadowColor: Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    height: 11.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 1,
                                      ),
                                    ),
                                    child: Stack(children: [
                                      Padding(
                                        // ignore: prefer_const_constructors
                                        padding: EdgeInsets.fromLTRB(
                                            5.w, 1.h, 0.w, 0),
                                        child: Text(
                                          'In the last 3 months have you had a vaccination',
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                            // ignore: prefer_const_constructors
                                            padding: EdgeInsets.fromLTRB(
                                                1.w, 4.5.h, 0.w, 1.h),
                                            child: RadioListTile<String>(
                                              title: const Text('Yes'),
                                              value: 'Yes',
                                              activeColor: PRIMARY_COLOR,
                                              groupValue: Q6,
                                              onChanged: (value) {
                                                setState(() {
                                                  Q6 = value!;
                                                });
                                              },
                                            ),
                                          )),
                                          Expanded(
                                              child: Padding(
                                            // ignore: prefer_const_constructors
                                            padding: EdgeInsets.fromLTRB(
                                                0.w, 4.5.h, 10.w, 1.h),
                                            child: RadioListTile<String>(
                                              title: const Text('No'),
                                              value: 'No',
                                              activeColor: PRIMARY_COLOR,
                                              groupValue: Q6,
                                              onChanged: (value) {
                                                setState(() {
                                                  Q6 = value!;
                                                });
                                              },
                                            ),
                                          )),
                                        ],
                                      )
                                    ]),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(2.w, 0.h, 0.w, 0),
                                    child: Checkbox(
                                      value: type == 'Yes',
                                      checkColor: Colors.white,
                                      focusColor: Colors.red,
                                      activeColor: Colors.red,

                                      // Check if ttype is 'donor'
                                      onChanged: (bool? value) {
                                        setState(() {
                                          type = value == true ? 'Yes' : '';
                                          terms = true;

                                          // Update ttype based on checkbox state
                                        });
                                      },
                                    ),
                                  ),
                                  Text(
                                    'By clicking, you agree to our terms and codition',
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              // Padding(
                              //   padding: EdgeInsets.fromLTRB(5.w, 0.h, 5.w, 0),
                              //   child: Material(
                              //     elevation: 10.0,
                              //     shadowColor: Colors.black,
                              //     borderRadius: BorderRadius.circular(10.0),
                              //     child: ElevatedButton(
                              //       onPressed: () {
                              //         if (type == 'Yes') {
                              //           if (Q1.isNotEmpty &&
                              //               Q2.isNotEmpty &&
                              //               Q3.isNotEmpty &&
                              //               Q4.isNotEmpty &&
                              //               Q5.isNotEmpty &&
                              //               Q6.isNotEmpty) {
                              //             setState(() {
                              //               showCircularProgressIndicator =
                              //                   true;
                              //             });
                              //             if (Q1 == 'Yes' ||
                              //                 Q2 == 'Yes' ||
                              //                 Q4 == 'Yes' ||
                              //                 Q5 == 'Yes') {
                              //               // authBloc.questionresult = true;
                              //               // bool response = authBloc.questionresult;
                              //               // authBloc.notifyListeners();

                              //               _showAlertDialog10(
                              //                 context,
                              //               );
                              //             } else {
                              //               _uploadImage();
                              //             }
                              //           } else {
                              //             _showAlertDialog6(context);
                              //           }
                              //         } else {
                              //           _showAlertDialog5(context);
                              //         }
                              //       },
                              //       style: ButtonStyle(
                              //         shape: MaterialStateProperty.all<
                              //             RoundedRectangleBorder>(
                              //           RoundedRectangleBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(10.0),
                              //           ),
                              //         ),
                              //         padding: MaterialStateProperty.all<
                              //             EdgeInsetsGeometry>(
                              //           // ignore: prefer_const_constructors
                              //           EdgeInsets.symmetric(
                              //               vertical: 13.5, horizontal: 35.w),
                              //         ),
                              //         backgroundColor: MaterialStateProperty
                              //             .all<Color>(const Color(
                              //                 0xFFDE0A1E)), // Change button color
                              //       ),
                              //       child: Stack(
                              //         alignment: Alignment.center,
                              //         children: [
                              //           if (showCircularProgressIndicator)
                              //             const SizedBox(
                              //               height: 20.0,
                              //               width: 20.0,
                              //               child: CircularProgressIndicator(
                              //                 strokeWidth: 2.0,
                              //                 valueColor:
                              //                     AlwaysStoppedAnimation<Color>(
                              //                         Colors.white),
                              //               ),
                              //             ),
                              //           if (!showCircularProgressIndicator)
                              //             Text(
                              //               'Continue',
                              //               style: TextStyle(
                              //                 fontSize: 12.sp,
                              //                 fontWeight: FontWeight.bold,
                              //                 color: Colors.white,
                              //               ),
                              //             ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 8.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(08), right: Radius.circular(08))),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      hidescanning == true
                          ? SizedBox()
                          : activeStep > 0
                              ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (activeStep > 0) activeStep--;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 7),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(05),
                                        color: Colors.black54),
                                    child: Text(
                                      'Back',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          if (activeStep == 0) {
                            if (image != null) {
                              print("image is $image");
                              if (_phonenumber.text.isNotEmpty) {
                                if (_password.text.toString() ==
                                    _conpassword.text.toString()) {
                                  if (_formkey.currentState != null &&
                                      _formkey.currentState!.validate()) {
                                    bool reult = await checkEmail();
                                    if (reult) {
                                      showDialogInfo('This Email is valid');
                                      setState(() {
                                        if (activeStep < 4) activeStep++;
                                      });
                                    } else {
                                      showDialogInfo(
                                          'This Email is already Exist. Please try another email!');
                                      _email.clear();
                                    }
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
                          }
                          // else if (activeStep == 1) {
                          //   if (otpsend == true) {
                          //     if (myauth.verifyOTP(otp: otp.text.trim()) ==
                          //         true) {
                          //       setState(() {
                          //         otpresult = true;
                          //       });
                          //       if (otpresult == true) {
                          //         setState(() {
                          //           if (activeStep < 4) activeStep++;
                          //         });
                          //       }
                          //     } else {
                          //       ScaffoldMessenger.of(context)
                          //           .showSnackBar(const SnackBar(
                          //         content: Text("OTP is incorrect"),
                          //       ));
                          //     }
                          //   } else {
                          //     ScaffoldMessenger.of(context)
                          //         .showSnackBar(const SnackBar(
                          //       content: Text("OTP is not sending"),
                          //     ));
                          //   }
                          // }
                          else if (activeStep == 1) {
                            setState(() {
                              if (activeStep < 4) activeStep++;
                            });
                          } else if (activeStep == 2) {
                            bool? result = await getCardScanningUsers();
                            if (result == true) {
                              bool? response = await addCnicCardDetail();
                              if (response == true) {
                                setState(() {
                                  if (activeStep < 4) activeStep++;
                                });
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    "Card number already matched! please try another cnic card number"),
                              ));
                            }
                          } else if (activeStep == 3) {
                            setState(() {});
                            await getNotificationToken();
                            if (type == 'Yes') {
                              if (Q1.isNotEmpty &&
                                  Q2.isNotEmpty &&
                                  Q3.isNotEmpty &&
                                  Q4.isNotEmpty &&
                                  Q5.isNotEmpty &&
                                  Q6.isNotEmpty) {
                                setState(() {
                                  showCircularProgressIndicator = true;
                                });
                                if (Q1 == 'Yes' ||
                                    Q2 == 'Yes' ||
                                    Q4 == 'Yes' ||
                                    Q5 == 'Yes') {
                                  // authBloc.questionresult = true;
                                  // bool response = authBloc.questionresult;
                                  // authBloc.notifyListeners();

                                  _showAlertDialog10(
                                    context,
                                  );
                                } else {
                                  _uploadImage();
                                }
                              } else {
                                _showAlertDialog6(context);
                              }
                            } else {
                              _showAlertDialog5(context);
                            }
                          }
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(05),
                              color: PRIMARY_COLOR),
                          child: activeStep == 4
                              ? Text(
                                  'Submit',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                )
                              : Text(
                                  'Next',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _cnicField({required TextEditingController textEditingController}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(08),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin:
          const EdgeInsets.only(top: 7.0, bottom: 1.0, left: 0.0, right: 0.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CNIC Number',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.card_membership,
                        color: Colors.red,
                      ),
                      // Image.asset("assets/images/cnic.png",
                      //     width: 40, height: 30),
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          decoration: InputDecoration(
                            hintText: '41000-0000000-0',
                            hintStyle: TextStyle(color: Color(kLightGreyColor)),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.only(left: 5.0),
                          ),
                          style: TextStyle(
                              color: Color(kDarkGreyColor),
                              fontWeight: FontWeight.bold),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _dataField(
      {required String text,
      required TextEditingController textEditingController}) {
    return Container(

        // shadowColor: Color(kShadowColor),
        // elevation: 5,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(08),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        margin: const EdgeInsets.only(
          top: 10,
          bottom: 5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Icon(
                (text == "Name") ? Icons.person : Icons.date_range,
                color: Colors.red,
                size: 17,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, top: 5, bottom: 3),
                    child: Text(
                      text.toUpperCase(),
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 5),
                    child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        hintText: (text == "Name") ? "User Name" : 'DD/MM/YYYY',
                        border: InputBorder.none,
                        isDense: true,
                        hintStyle: TextStyle(
                            color: Color(kLightGreyColor),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        contentPadding: EdgeInsets.all(0),
                      ),
                      style: TextStyle(
                          color: Color(kDarkGreyColor),
                          fontWeight: FontWeight.bold),
                      textInputAction: TextInputAction.done,
                      keyboardType: (text == "Name")
                          ? TextInputType.text
                          : TextInputType.number,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _getScanCNICBtn() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        textStyle: TextStyle(color: Colors.white),
        padding: EdgeInsets.all(0.0),
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(onCameraBTNPressed: () {
                scanCnic(ImageSource.camera);
              }, onGalleryBTNPressed: () {
                _showAlertDialog11(context);

                // scanCnic(ImageSource.gallery);
              });
            });
      },
      // textColor: Colors.white,
      // padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: 500,
        decoration: BoxDecoration(
          color: PRIMARY_COLOR,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('Scan CNIC',
            style: TextStyle(fontSize: 15, color: Colors.white)),
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        textStyle: TextStyle(color: Colors.white),
        padding: EdgeInsets.all(0.0),
      ),
      onPressed: () {},
      child: Container(
        alignment: Alignment.center,
        width: 500,
        decoration: BoxDecoration(
          color: PRIMARY_COLOR,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        padding: const EdgeInsets.all(12.0),
        child:
            Text('Submit', style: TextStyle(fontSize: 15, color: Colors.white)),
      ),
    );
  }

  Widget _customRow(int index, String value, {bool showIcon = false}) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Container(
              alignment: Alignment.center,
              height: 5.h,
              width: 5.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.red.shade100.withOpacity(0.5),
              ),
              child: showIcon
                  ? Icon(
                      Icons.check, // Replace with the desired icon
                      color: Colors.black,
                      size: 18.sp,
                    )
                  : correctcnic == true
                      ? Icon(
                          Icons.check, // Replace with the desired icon
                          color: Colors.black,
                          size: 18.sp,
                        )
                      : Text(
                          index.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp,
                          ),
                        ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 12.sp,
              ),
            )
          ],
        ),
        SizedBox(
          height: 1.h,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.black45,
          ),
        )
      ],
    );
  }

  // void _showFileSizeExceededMessage() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('File Size Exceeded'),
  //         content: Text(
  //             'The selected image exceeds the maximum allowed size of 1MB. Please select a smaller image.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // ignore: unused_element
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

  Future<bool> getCardScanningUsers() async {
    try {
      showLoader("please wait");
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('card_scanning_users')
          .where('card_number', isEqualTo: cnicTEController.text.trim())
          .get();

      if (querySnapshot.docs.isEmpty) {
        EasyLoading.dismiss();
        return true;
      } else {
        EasyLoading.dismiss();
        return false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      print('Error: $e');
      return false;
    }
  }

  Future<bool> addCnicCardDetail() async {
    try {
      showLoader("please wait");
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      // Store additional user information in Firestore
      await _firestore.collection('card_scanning_users').add({
        'email': _email.text.trim(),
        'card_user_name': nameTEController.text.trim(),
        'card_number': cnicTEController.text.trim(),
        'date_of_birth': dobTEController.text.trim(),
        'date_of_cardissue': doiTEController.text.trim(),
        'date_of_cardexpire': doeTEController.text.trim(),
        'card_image': "",
      });
      setState(() {
        correctcnic = true;
        hidescanning = true;
      });
      EasyLoading.dismiss();
      return true;
    } catch (error) {
      EasyLoading.dismiss();
      // ignore: avoid_print
      print("Error in _handleSignup: $error");
      return false;
      // Handle error and show a proper error message to the user
    }
  }

  // Future<void> cardUploadImage() async {
  //   // ignore: unnecessary_null_comparison
  //   if (widget.image == null) return;

  //   final Reference storageReference = FirebaseStorage.instance
  //       .ref()
  //       .child('profile_images/${DateTime.now()}.jpg');

  //   final UploadTask uploadTask = storageReference.putFile(File(widget.image));
  //   await uploadTask.whenComplete(() => null);

  //   final imageUrl = await storageReference.getDownloadURL();

  //   setState(() {
  //     picture = imageUrl;
  //   });
  //   _handleSignup();
  // }

  Future<bool> checkEmail() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    CollectionReference users = _firestore.collection('users');

    try {
      showLoader('please wait');
      // Check if email exists in Firestore 'users' collection
      QuerySnapshot existingUsers =
          await users.where('email', isEqualTo: _email.text.trim()).get();

      if (existingUsers.docs.isNotEmpty) {
        // Email exists in Firestore
        print("Email found in Firestore users collection.");
        EasyLoading.dismiss();
        return false;
      }

      // Check if email exists in Firebase Authentication
      List<String> signInMethods =
          await _auth.fetchSignInMethodsForEmail(_email.text.trim());

      if (signInMethods.isNotEmpty) {
        // Email exists in Firebase Authentication
        print("Email found in Firebase Authentication.");
        EasyLoading.dismiss();
        return false;
      }

      print("Email does not exist in Firestore or Firebase Authentication.");
      EasyLoading.dismiss();
      return true;
    } catch (error) {
      // Handle and log errors
      print("Error in checkEmail: $error");
      EasyLoading.dismiss();
      return false;
    }
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

  Widget _buildStepIcon({required bool isActive, required bool isCompleted}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCompleted || isActive
              ? [
                  Colors.red,
                  Colors.redAccent
                ] // Red gradient for completed or active
              : [
                  Colors.red.shade400,
                  Colors.red.shade600
                ], // Slightly darker red for inactive
        ),
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: 12,
        backgroundColor: Colors.transparent,
        child: isCompleted
            ? Icon(Icons.check, color: Colors.white, size: 14)
            : Icon(
                Icons.circle,
                color: Colors.white,
                size: isActive ? 14 : 12,
              ),
      ),
    );
  }

  void _showAlertDialog10(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text(
              'You are not Eligible for donate Blood Only you have take the Blood.\nClick on OK button then create a simple account'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the alert dialog
                Navigator.pop(context);
                _uploadImage1();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialog11(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(
            'You are not allow to scan Cnic from gallary',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(color: PRIMARY_COLOR),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialog6(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Must be Check Questionares!'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the alert dialog
                setState(() {
                  showCircularProgressIndicator = false;
                });
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialog5(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Please must be check Terms and Conditions:'),
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

  Future<void> _uploadImage() async {
    showLoader('please wait');
    picture = image?.path.toString() ?? '';
    // ignore: unnecessary_null_comparison
    if (picture == null) return;

    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('profile_images/${DateTime.now()}.jpg');

    final UploadTask uploadTask = storageReference.putFile(File(picture));
    await uploadTask.whenComplete(() => null);

    final imageUrl = await storageReference.getDownloadURL();

    setState(() {
      picture1 = imageUrl;
    });
    EasyLoading.dismiss();
    _handleSignup();
  }

  Future<void> _uploadImage1() async {
    showLoader('please wait');
    picture = image?.path.toString() ?? '';
    // ignore: unnecessary_null_comparison
    if (picture == null) return;

    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('profile_images/${DateTime.now()}.jpg');

    final UploadTask uploadTask = storageReference.putFile(File(picture));
    await uploadTask.whenComplete(() => null);

    final imageUrl = await storageReference.getDownloadURL();

    setState(() {
      picture1 = imageUrl;
    });
    EasyLoading.dismiss();
    _handleSignup1();
  }

  void _handleSignup() async {
    try {
      showLoader("please wait");

      print(token);
      String number = '0${_phone}';
      CollectionReference users = _firestore.collection('users');
      QuerySnapshot existingUsers =
          await users.where('email', isEqualTo: _email.text.trim()).get();

      if (existingUsers.docs.isNotEmpty) {
        _showAlertDialog1(context);
        EasyLoading.dismiss();
      } else {
        UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text.trim(),
        );

        // String profileImageUrl = widget.image;

        // // ignore: unnecessary_null_comparison
        // ignore: unnecessary_null_comparison
        // if (profileImageUrl != null) {
        //   final File imageFile = File(profileImageUrl);

        //   final storageRef = FirebaseStorage.instance
        //       .ref()
        //       .child('profile_images/${result.user?.uid}.jpg');

        //   await storageRef.putFile(imageFile);
        //   profileImageUrl = await storageRef.getDownloadURL();
        // }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_uid', result.user?.uid ?? '');
        prefs.setString('user_email', _email.text.trim());
        user_id = result.user!.uid;
        // print('Add');

        // Store additional user information in Firestore
        await _firestore.collection('users').doc(result.user?.uid).set({
          'id': result.user?.uid,
          'firstname': _fname.text.trim(),
          'lastname': _lname.text.trim(),
          'deviceToken': token.toString(),
          'phonenumber': '0${_phonenumber.text.trim()}',
          'email': _email.text.trim(),
          'location': _location.text.trim(),
          'bloodgroup': selectedIndex1,
          'gender': selectedIndex,
          'password': _password.text.trim(),
          'image': picture1,
          'type': 'donor',
          'status': false,
          'availabledonate': false
        });

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text.trim(),
        );
        String name = _fname.text.trim() + " " + _fname.text.trim();
        EasyLoading.showSuccess('Create Account Successfully!');
        // authBloc.questionresult = true;
        // authBloc.notifyListeners();
        showCircularProgressIndicator = false;
        hidescanning = false;
        setState(() {});
        Future.delayed(Duration(microseconds: 500), () {
          _usereligible();
          _userAddLocations(name, _location.text.trim(), picture1);
        });
        EasyLoading.dismiss();

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const Dashboard();
            },
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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
      }

      // Navigate to the home page or another screen after successful signup
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (error) {
      EasyLoading.dismiss();
      // ignore: avoid_print
      print("Error in _handleSignup: $error");
      setState(() {
        showCircularProgressIndicator = false;
        EasyLoading.showError(
            "The email address is already in use by another account");
      });
    }
  }

  // Future<void> _uploadImage() async {
  //   if (widget.image.isEmpty) return;

  //   final Reference storageReference = FirebaseStorage.instance
  //       .ref()
  //       .child('profile_images/${DateTime.now()}.jpg');

  //   final UploadTask uploadTask = storageReference.putFile(File(widget.image));
  //   await uploadTask.whenComplete(() => null);

  //   final imageUrl = await storageReference.getDownloadURL();

  //   setState(() {
  //     _imageUrl = imageUrl;
  //   });
  //   _handleSignup();
  // }

  void _handleSignup1() async {
    try {
      showLoader('please wait');
      final authprovider = Provider.of<MyPageProvider>(context, listen: false);
      print(token);

      CollectionReference users = _firestore.collection('users');
      QuerySnapshot existingUsers =
          await users.where('email', isEqualTo: _email.text.trim()).get();

      if (existingUsers.docs.isNotEmpty) {
        _showAlertDialog1(context);
        EasyLoading.dismiss();
      } else {
        UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text.trim(),
        );

        String profileImageUrl = picture;

        // // ignore: unnecessary_null_comparison
        // ignore: unnecessary_null_comparison
        if (profileImageUrl != null) {
          final File imageFile = File(profileImageUrl);

          final storageRef = FirebaseStorage.instance
              .ref()
              .child('profile_images/${result.user?.uid}.jpg');

          await storageRef.putFile(imageFile);
          profileImageUrl = await storageRef.getDownloadURL();
        }

        user_id = result.user!.uid;
        authprovider.notifyListeners();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_uid', result.user?.uid ?? '');
        prefs.setString('user_email', _email.text.trim());
        prefs.setString('user_image', picture1);
        // print('Add');

        // Store additional user information in Firestore
        await _firestore.collection('users').doc(result.user?.uid).set({
          'id': result.user?.uid,
          'firstname': _fname.text.trim(),
          'lastname': _lname.text.trim(),
          'deviceToken': token.toString(),
          'phonenumber': '0${_phonenumber.text.trim()}',
          'email': _email.text.trim(),
          'location': _location.text.trim(),
          'bloodgroup': selectedIndex1,
          'gender': selectedIndex,
          'password': '0${_password.text.trim()}',
          'image': picture1,
          'type': 'taker',
          'status': false,
          'availabledonate': false
        });

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text.trim(),
        );
        EasyLoading.showSuccess('Create Acccount Successfully!');

        showCircularProgressIndicator = false;
        hidescanning = false;
        setState(() {});
        Future.delayed(Duration(microseconds: 500), () {
          _usereligible1();
        });
        EasyLoading.dismiss();

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const Dashboard();
            },
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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
      }

      // Navigate to the home page or another screen after successful signup
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (error) {
      EasyLoading.dismiss();
      // ignore: avoid_print
      print("Error in _handleSignup: $error");
      // Handle error and show a proper error message to the user
    }
  }

  void _userAddLocations(String name, String location, String image) async {
    try {
      // Store additional user information in Firestore
      await _firestore.collection('donor_location').add({
        'user_id': user_id,
        'donor_name': name,
        'donor_location': location,
        'donor_image': image
      });
    } catch (error) {
      // ignore: avoid_print
      print("Error in _handleSignup: $error");
      // Handle error and show a proper error message to the user
    }
  }

  void _usereligible1() async {
    try {
      // Store additional user information in Firestore
      await _firestore.collection('terms_condition').add({
        'user_id': user_id,
        'donation_process': false,
        'eligibility': false,
        'hygiene': false,
        'safety': false,
        'privacy_policy': true,
      });
    } catch (error) {
      // ignore: avoid_print
      print("Error in _handleSignup: $error");
      // Handle error and show a proper error message to the user
    }
  }

  void _usereligible() async {
    try {
      // Store additional user information in Firestore
      await _firestore.collection('terms_condition').add({
        'user_id': user_id,
        'donation_process': true,
        'eligibility': true,
        'hygiene': true,
        'safety': true,
        'privacy_policy': true
      });
    } catch (error) {
      // ignore: avoid_print
      print("Error in _handleSignup: $error");
      // Handle error and show a proper error message to the user
    }
  }

  // void addDataToFirestore() async {
  //   // ignore: unrelated_type_equality_checks

  //   FirebaseFirestore firestore = FirebaseFirestore.instance;

  //   CollectionReference users = firestore.collection('users');
  //   QuerySnapshot existingUsers =
  //       await users.where('email', isEqualTo: widget.email).get();
  //   if (existingUsers.docs.isNotEmpty) {
  //     // ignore: use_build_context_synchronously
  //     _showAlertDialog1(context);
  //   } else {
  //     await users.add({
  //       'id': widget.id,
  //       'firstname': widget.fname,
  //       'lastname': widget.lname,
  //       'phonenumber': widget.number,
  //       'email': widget.email,
  //       'location': widget.location,
  //       'bloodgroup': widget.blood,
  //       'gender': widget.gender,
  //       'password': widget.password,
  //       'image': widget.image,
  //       'type': 'donor'
  //     });
  //     // ignore: use_build_context_synchronously
  //     Navigator.pushReplacement(
  //       context,
  //       PageRouteBuilder(
  //         pageBuilder: (context, animation, secondaryAnimation) {
  //           return const Dashboard();
  //         },
  //         transitionDuration: const Duration(seconds: 1),
  //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //           const begin = Offset(10.0, 0.0); // slide in from the right
  //           const end = Offset.zero;
  //           const curve = Curves.easeInOutQuart;

  //           var tween =
  //               Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  //           var offsetAnimation = animation.drive(tween);

  //           return SlideTransition(
  //             position: offsetAnimation,
  //             child: child,
  //           );
  //         },
  //       ),
  //     );
  //   }
  //   // ignore: avoid_print
  //   print('User data added to Firestore!');
  // }

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
                setState(() {
                  showCircularProgressIndicator = false;
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class CustomStepper extends StatelessWidget {
  CustomStepper({
    Key? key,
    required this.currentStep,
    required this.steps,
    this.activeColor = Colors.black,
    this.inactiveColor = Colors.grey,
    this.lineWidth = 5.0,
    this.iconSize = 55.0,
  })  : assert(currentStep >= 0 && currentStep < steps.length),
        super(key: key);

  final int currentStep;
  final List<Map<String, dynamic>> steps;
  final Color activeColor;
  final Color inactiveColor;
  final double lineWidth;
  final double iconSize;

  List<Widget> _iconViews() {
    var list = <Widget>[];
    steps.asMap().forEach((i, icon) {
      Color circleColor =
          (i == 0 || currentStep >= i) ? activeColor : inactiveColor;
      Color lineColor = currentStep > i ? activeColor : inactiveColor;

      list.add(
        Container(
          width: iconSize,
          height: iconSize,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor,
          ),
          child: SvgPicture.asset(
            icon['image'],
            fit: BoxFit.contain,
          ),
        ),
      );
      if (i != steps.length - 1) {
        list.add(
          Expanded(
            child: Container(
              height: lineWidth,
              color: lineColor,
            ),
          ),
        );
      }
    });

    return list;
  }

  List<Widget> _titleViews() {
    var list = <Widget>[];
    steps.asMap().forEach((i, text) {
      list.add(
        Expanded(
          child: Text(
            text['title'],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: currentStep >= i ? activeColor : inactiveColor,
            ),
          ),
        ),
      );
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _titleViews(),
        ),
        const SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _iconViews(),
          ),
        ),
      ],
    );
  }
}

class NewPage extends StatefulWidget {
  const NewPage({super.key});

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
