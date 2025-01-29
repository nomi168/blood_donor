import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../Dashoard/Dashboatd.dart';

class EditProfile extends StatefulWidget {
  final String image;
  final String firstname;
  final String lastname;
  final String location;
  final String blood;
  final String id;
  const EditProfile(
      {super.key,
      required this.image,
      required this.firstname,
      required this.lastname,
      required this.location,
      required this.blood,
      required this.id});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? image;
  List<String> nomi = ['Male', 'Female'];
  String selectedIndex = '';
  List<String> nomi1 = ['A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-', 'AB-'];
  String selectedIndex1 = '';
  String type = ''; // Default country code
  String mobileNumber = '';
  bool showCircularProgressIndicator = false;
  String picture = '';
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController _location = TextEditingController();
  TextEditingController _fname = TextEditingController();

  TextEditingController _lname = TextEditingController();

  // ignore: unused_field

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // final fileSize = await pickedFile.length();
      // const maxFileSize = 1 * 1024 * 1024; // 1MB in bytes

      // if (fileSize > maxFileSize) {
      //   // File size exceeds 1MB, compress the image
      //   // final compressedFile = await _compressImage(File(pickedFile.path));
      //   // final compressedFileSize = await compressedFile.length();

      //   // if (compressedFileSize > maxFileSize) {
      //   //   _showFileSizeExceededMessage();
      //   // } else {
      //   //   setState(() {
      //   //     image = compressedFile as File?;
      //   //   });
      //   // }
      // } else {
      setState(() {
        image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
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

  // ignore: unused_element

  String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Location is required';
    }
    return null; // Indicates a valid location
  }

  String? validateBlood(String? value) {
    if (value == null || value.isEmpty) {
      return 'Blood is required';
    }
    return null; // Indicates a valid gender
  }

  @override
  void initState() {
    _fname.text = widget.firstname;
    _lname.text = widget.lastname;
    _location.text = widget.location;

    super.initState();
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
                            : NetworkImage(widget.image)
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
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
                child: Material(
                  elevation: 2.5,
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  child: TextFormField(
                    controller: _fname,
                    decoration: InputDecoration(
                      label: const Text(
                        'First Name',
                        style: TextStyle(fontSize: 15, color: Colors.black45),
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
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
                child: Material(
                  elevation: 2.5, // Add shadow/elevation
                  borderRadius:
                      BorderRadius.circular(10.0), // Add border radius
                  child: TextFormField(
                    controller: _lname,
                    decoration: InputDecoration(
                      label: const Text(
                        'Last Name',
                        style: TextStyle(fontSize: 15, color: Colors.black45),
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
                            color: Colors.white), // Border color when focused
                      ),
                      // hintText: 'Last Name',
                    ),
                    validator: _validateLastName,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 2.4.h, 5.w, 0),
                child: Material(
                  elevation: 2.5, // Add shadow/elevation
                  borderRadius:
                      BorderRadius.circular(10.0), // Add border radius
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
                        borderSide: const BorderSide(
                            color: Colors.grey), // Border color
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
              Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 2.4.h, 5.w, 0),
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showCircularProgressIndicator = true;
                    });
                    if (_formkey.currentState != null &&
                        _formkey.currentState!.validate()) {
                      updateProfile();
                    }
                    // ignore: unnecessary_null_comparison
                    // if (image != null) {
                    //   print("image is $image");
                    //   if (_phonenumber.text.isNotEmpty) {
                    //     if (_password.text.toString() ==
                    //         _conpassword.text.toString()) {
                    //       if (_formkey.currentState != null &&
                    //           _formkey.currentState!.validate()) {
                    //         String email = _email.text;
                    //         // ignore: unused_local_variable
                    //         int Id = id;
                    //         String iimage = image!.path.toString();
                    //         print(iimage);
                    //         String fname = _fname.text;
                    //         String lname = _lname.text;
                    //         String number = _phonenumber.text;
                    //         String location = _location.text;
                    //         String blood = selectedIndex1;
                    //         String gender = selectedIndex;
                    //         String password = _password.text;
                    //         Navigator.push(
                    //           context,
                    //           PageRouteBuilder(
                    //             pageBuilder:
                    //                 (context, animation, secondaryAnimation) {
                    //               return OTPSignup(
                    //                   email: email,
                    //                   Id: id,
                    //                   image: iimage,
                    //                   fname: fname,
                    //                   lname: lname,
                    //                   number: number,
                    //                   location: location,
                    //                   blood: blood,
                    //                   gender: gender,
                    //                   password: password);
                    //             },
                    //             transitionDuration:
                    //                 const Duration(seconds: 1),
                    //             transitionsBuilder: (context, animation,
                    //                 secondaryAnimation, child) {
                    //               const begin = Offset(
                    //                   10.0, 0.0); // slide in from the right
                    //               const end = Offset.zero;
                    //               const curve = Curves.easeInOutQuart;

                    //               var tween = Tween(begin: begin, end: end)
                    //                   .chain(CurveTween(curve: curve));
                    //               var offsetAnimation =
                    //                   animation.drive(tween);

                    //               return SlideTransition(
                    //                 position: offsetAnimation,
                    //                 child: child,
                    //               );
                    //             },
                    //           ),
                    //         );
                    //       }
                    //     } else {
                    //       _showAlertDialog2(context);
                    //     }
                    //   } else {
                    //     _showAlertDialog4(context);
                    //   }
                    // } else {
                    //   EasyLoading.showInfo("Must e upload Picture");
                    // }
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
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (showCircularProgressIndicator)
                        const SizedBox(
                          height: 22.0, // Set your desired height here
                          width: 22.0, // Set your desired width here
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
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
              )
            ],
          ),
        ));
  }

  Future<void> updateProfile() async {
    try {
      // Query Firestore to get the document that matches the user's email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: widget.id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document reference
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String documentId = documentSnapshot.id;
        String profileImageUrl = image!.path.toString();

        // // ignore: unnecessary_null_comparison
        // ignore: unnecessary_null_comparison
        if (profileImageUrl != null) {
          final File imageFile = File(profileImageUrl);

          final storageRef = FirebaseStorage.instance
              .ref()
              .child('profile_images/${widget.id}.jpg');

          await storageRef.putFile(imageFile);
          profileImageUrl = await storageRef.getDownloadURL();
        }

        // Update the data in the document
        await FirebaseFirestore.instance
            .collection('users')
            .doc(documentId)
            .update({
          'firstname': _fname.text,
          'lastname': _lname.text,
          'location': _location.text,
          'blood': selectedIndex1,
          'image': profileImageUrl
        });
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
        EasyLoading.showSuccess('Data updated Successfully');

        print('Data updated successfully in acceptdonation table');
      } else {
        setState(() {
          showCircularProgressIndicator = false;
        });
        print('User not found with email: ${widget.id}');
      }
    } catch (e) {
      setState(() {
        showCircularProgressIndicator = false;
      });
      print('Error: $e');
    }
  }
}
