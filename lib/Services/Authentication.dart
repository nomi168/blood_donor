// ignore_for_file: file_names
import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(String email, String password) async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set the user in the AuthProvider
      Provider.of<AuthProvider>(context as BuildContext, listen: false)
          .providerId;
    } catch (e) {
      // Handle login errors
      print('Login error: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();

      // Set the user in the AuthProvider to null
      Provider.of<AuthProvider>(context as BuildContext, listen: false)
          .providerId;
    } catch (e) {
      // Handle logout errors
      print('Logout error: $e');
    }
  }

  // void _handleSignup() async {
  //   try {
  //     CollectionReference users = _firestore.collection('users');
  //     QuerySnapshot existingUsers =
  //         await users.where('email', isEqualTo: widget.email).get();

  //     if (existingUsers.docs.isNotEmpty) {
  //       // ignore: use_build_context_synchronously
  //       _showAlertDialog1(context);
  //     } else {
  //       UserCredential result = await _auth.createUserWithEmailAndPassword(
  //         email: widget.email,
  //         password: widget.password,
  //       );

  //       String profileImageUrl = widget.image;

  //       // // ignore: unnecessary_null_comparison
  //       // ignore: unnecessary_null_comparison
  //       if (profileImageUrl != null) {
  //         final File imageFile = File(profileImageUrl);

  //         final storageRef = FirebaseStorage.instance
  //             .ref()
  //             .child('profile_images/${result.user?.uid}.jpg');

  //         await storageRef.putFile(imageFile);
  //         profileImageUrl = await storageRef.getDownloadURL();
  //       }
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       prefs.setString('user_uid', result.user?.uid ?? '');
  //       // print('Add');

  //       // Store additional user information in Firestore
  //       await _firestore.collection('users').doc(result.user?.uid).set({
  //         'id': widget.id,
  //         'firstname': widget.fname,
  //         'lastname': widget.lname,
  //         'phonenumber': widget.number,
  //         'email': widget.email,
  //         'location': widget.location,
  //         'bloodgroup': widget.blood,
  //         'gender': widget.gender,
  //         'password': widget.password,
  //         'image': widget.image,
  //         'type': 'donor'
  //       });

  //       await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: widget.email,
  //         password: widget.password,
  //       );

  //       // ignore: use_build_context_synchronously
  //       Navigator.pushReplacement(
  //         context as BuildContext,
  //         PageRouteBuilder(
  //           pageBuilder: (context, animation, secondaryAnimation) {
  //             return const Dashboard();
  //           },
  //           transitionDuration: const Duration(seconds: 1),
  //           transitionsBuilder:
  //               (context, animation, secondaryAnimation, child) {
  //             const begin = Offset(10.0, 0.0); // slide in from the right
  //             const end = Offset.zero;
  //             const curve = Curves.easeInOutQuart;

  //             var tween =
  //                 Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  //             var offsetAnimation = animation.drive(tween);

  //             return SlideTransition(
  //               position: offsetAnimation,
  //               child: child,
  //             );
  //           },
  //         ),
  //       );
  //     }

  //     // Navigate to the home page or another screen after successful signup
  //     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
  //   } catch (error) {
  //     // ignore: avoid_print
  //     print("Error in _handleSignup: $error");
  //     // Handle error and show a proper error message to the user
  //   }
  // }
}
