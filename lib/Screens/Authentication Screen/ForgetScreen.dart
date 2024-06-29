// ignore_for_file: file_names

import 'package:blood_donor/Screens/Main%20Screen/Dashoard/Dashboatd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ForgetScreen extends StatefulWidget {
  final String email;
  const ForgetScreen({super.key, required this.email});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  TextEditingController pass = TextEditingController();
  TextEditingController cpass = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? validatePassword(String? value) {
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

  bool _obscureText = false;
  bool _obscureText1 = false;

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
                    child: ListView(children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.w, 0, 0.w, 0.h),
                        child: Center(
                            child: Image.network(
                                'https://wallpapercave.com/wp/wp4323467.jpg')),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0.w, 5.h, 0, 0),
                          child: Center(
                            child: Text(
                              'Forget Password',
                              style: TextStyle(
                                  fontSize: 20.sp, fontWeight: FontWeight.bold),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
                        child: Material(
                          elevation: 7.0,
                          borderRadius: BorderRadius.circular(10.0),
                          child: TextFormField(
                            controller: pass,
                            obscureText:
                                _obscureText, // Set to true to obscure text
                            decoration: InputDecoration(
                              label: const Text('New Password'),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
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
                            obscureText: _obscureText1,
                            controller: cpass,
                            decoration: InputDecoration(
                              label: const Text('Confirm Password'),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0), // Adjust padding
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                    color: Colors.grey), // Border color
                              ),
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
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                // Border color when focused
                              ),
                              hintText: 'Confirm Password',
                            ),
                            validator: validatePassword,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
                        child: Material(
                          elevation: 10.0,
                          shadowColor: Colors.black,
                          borderRadius: BorderRadius.circular(10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formkey.currentState?.validate() ?? false) {
                                if (pass.text == cpass.text) {
                                  ForgetPassword();
                                } else {
                                  _showAlertDialog2(context);
                                }
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
                                  Colors.red), // Change button color
                            ),
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 12.sp, // Adjust the font size
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]))));
      },
    );
  }

  // ignore: non_constant_identifier_names
  void ForgetPassword() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String email = widget.email.trim();

    CollectionReference users = firestore.collection('users');
    QuerySnapshot existingUsers =
        await users.where('email', isEqualTo: email).get();

    if (existingUsers.docs.isNotEmpty) {
      // User found, update password
      DocumentSnapshot userDoc = existingUsers.docs.first;
      String userId = userDoc.id;

      await users.doc(userId).update({
        'password': pass.text
        // replace _newPassword with your password variable
      });

      // After updating the password, proceed with the login
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const Dashboard();
          },
          transitionDuration: const Duration(seconds: 1),
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
    } else {
      // User not found or incorrect email, show an alert or handle accordingly
      // ignore: use_build_context_synchronously
      _showAlertDialog1(context);
    }
  }

  void _showAlertDialog1(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Please Enter Email is correct'),
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
}
