// ignore_for_file: file_names, use_build_context_synchronously
import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/validate_test_field.dart';
import 'package:blood_donor/features/auth/presentation/controllers/login_controller.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/auth/presentation/screens/forgot_screen.dart';
import 'package:blood_donor/features/auth/presentation/screens/signup_screen.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/dashboatd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(child: SvgPicture.asset('images/svg/Login.svg')),
              GetBuilder<LoginController>(
                  init: LoginController(),
                  builder: (controller) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.w, 4.h, 0, 0),
                          child: Center(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 20.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: Material(
                            elevation: 2.5,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            child: TextFormField(
                              controller: controller.email,
                              decoration: InputDecoration(
                                label: const Text(
                                  'Email',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black45),
                                ),
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
                                      const BorderSide(color: Colors.white),
                                ),
                              ),
                              validator: validateEmail,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: Material(
                            color: Colors.white,
                            elevation: 2.5,
                            borderRadius: BorderRadius.circular(10.0),
                            child: TextFormField(
                              controller: controller.password,
                              obscureText: !controller.isPasswordVisible,
                              decoration: InputDecoration(
                                label: const Text(
                                  'Password',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black45),
                                ),
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
                                      const BorderSide(color: Colors.white),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    controller.isPasswordVisible =
                                        !controller.isPasswordVisible;
                                    controller.update();
                                  },
                                ),
                              ),
                              validator: validatePassword,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 10),
                          child: TextButton(
                            child: Text(
                              'Forgot Password',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFDE0A1E),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return const OTPForgetScreen();
                                  },
                                  transitionDuration:
                                      const Duration(microseconds: 100),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(10.0, 0.0);
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
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          splashFactory: NoSplash.splashFactory,
                          onTap: () async {
                            if (controller.email.text.isEmpty) {
                              Get.snackbar(
                                "Error",
                                "Email is required",
                                snackPosition: SnackPosition.TOP,
                                snackStyle: SnackStyle.FLOATING,
                                backgroundColor:
                                    Colors.red.withValues(alpha: 0.9),
                                colorText: Colors.white,
                                margin: EdgeInsets.all(10),
                                duration: Duration(seconds: 3),
                                borderRadius: 8,
                                icon: Icon(Icons.error, color: Colors.white),
                              );

                              return;
                            }
                            if (!controller.email.text.contains('@')) {
                              Get.snackbar(
                                "Error",
                                "Email is invalid",
                                snackPosition: SnackPosition.TOP,
                                snackStyle: SnackStyle.FLOATING,
                                backgroundColor:
                                    Colors.red.withValues(alpha: 0.9),
                                colorText: Colors.white,
                                margin: EdgeInsets.all(10),
                                duration: Duration(seconds: 3),
                                borderRadius: 8,
                                icon: Icon(Icons.error, color: Colors.white),
                              );

                              return;
                            }
                            if (controller.password.text.isEmpty) {
                              Get.snackbar(
                                "Error",
                                "Password is required",
                                snackPosition: SnackPosition.TOP,
                                snackStyle: SnackStyle.FLOATING,
                                backgroundColor:
                                    Colors.red.withValues(alpha: 0.9),
                                colorText: Colors.white,
                                margin: EdgeInsets.all(10),
                                duration: Duration(seconds: 3),
                                borderRadius: 8,
                                icon: Icon(Icons.error, color: Colors.white),
                              );

                              return;
                            }
                            controller.userModel =
                                await controller.loginToFirebase(
                                    controller.email.text.trim(),
                                    controller.password.text.trim());
                            if (controller.userModel != null) {
                              await Get.put(UserController(), permanent: true);
                              UserController.to.userModel =
                                  controller.userModel;
                              UserController.to.isUserData = true;
                              controller.update();
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              controller.userModel!.email;
                              prefs.setString(
                                  'user_email', controller.userModel!.email);

                              prefs.setString(
                                  'user_uid', controller.userModel!.id);
                              Get.snackbar(
                                "Success",
                                "login successfully",
                                snackPosition: SnackPosition.TOP,
                                snackStyle: SnackStyle.FLOATING,
                                backgroundColor:
                                    Colors.green.withValues(alpha: 0.9),
                                colorText: Colors.white,
                                margin: EdgeInsets.all(10),
                                duration: Duration(seconds: 3),
                                borderRadius: 8,
                                icon: Icon(Icons.check_circle,
                                    color: Colors.white),
                              );
                              controller.email.clear();
                              controller.password.clear();

                              Get.offAll(() => Dashboard());
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: PRIMARY_COLOR,
                                borderRadius: BorderRadius.circular(05)),

                            // margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 10),
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(5.w, 2.h, 0, 0),
                              child: Center(
                                child: Text(
                                  'If you want to create account:',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpScreen()));
                              },
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(1.w, 2.h, 0, 0),
                                child: Center(
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )

                        // Padding(
                        //   padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
                        //   child: Material(
                        //     elevation: 3.5,
                        //     shadowColor: Colors.black,
                        //     borderRadius: BorderRadius.circular(10.0),
                        //     child: ElevatedButton(
                        //       onPressed: () {
                        //         authenticateWithFingerprint();
                        //       },
                        //       style: ButtonStyle(
                        //         shape:
                        //             MaterialStateProperty.all<RoundedRectangleBorder>(
                        //           RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(10.0),
                        //           ),
                        //         ),
                        //         padding:
                        //             MaterialStateProperty.all<EdgeInsetsGeometry>(
                        //           EdgeInsets.symmetric(vertical: 13.5, horizontal: 0),
                        //         ),
                        //         backgroundColor: MaterialStateProperty.all<Color>(
                        //             const Color(0xFFDE0A1E)),
                        //       ),
                        //       child: Stack(
                        //         alignment: Alignment.center,
                        //         children: [
                        //           Text(
                        //             'Login with Fingerprint',
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
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // _checkBio();
//   }

//   void loginToFirestore() async {
//     final email = _email.text.trim();
//     final password = _password.text.trim();

//     if (email.isEmpty || !email.contains('@')) {
//       EasyLoading.showError('Invalid email format');
//       return;
//     }
//     if (password.isEmpty) {
//       EasyLoading.showError('Password cannot be empty');
//       return;
//     }

//     try {
//       UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       userCredential;

//       DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userCredential.user?.uid)
//           .get();

//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setString('user_uid', userCredential.user?.uid ?? '');
//       prefs.setString('user_email', email);

//       if (userSnapshot.exists) {
//         EasyLoading.showSuccess('Login Successfully!');
//         profile.email = email;
//         Navigator.pushReplacement(
//           context,
//           PageRouteBuilder(
//             pageBuilder: (context, animation, secondaryAnimation) {
//               return const Dashboard();
//             },
//             transitionDuration: const Duration(seconds: 1),
//             transitionsBuilder:
//                 (context, animation, secondaryAnimation, child) {
//               const begin = Offset(10.0, 0.0);
//               const end = Offset.zero;
//               const curve = Curves.easeInOutQuart;

//               var tween =
//                   Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//               var offsetAnimation = animation.drive(tween);

//               return SlideTransition(
//                 position: offsetAnimation,
//                 child: child,
//               );
//             },
//           ),
//         );
//       } else {
//         _showUserNotFoundDialog(context);
//         setState(() {
//           showCircularProgressIndicator = false;
//         });
//       }
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'invalid-credential') {
//         _showPasswordIncorrectDialog(context);
//       } else {
//         print('Login failed: $e');
//         _showUserNotFoundDialog(context);
//       }
//       setState(() {
//         showCircularProgressIndicator = false;
//       });
//     } catch (e) {
//       print('Error: $e');
//       setState(() {
//         showCircularProgressIndicator = false;
//       });
//     }
//   }

//   // void loginToFirestore() async {
//   //   try {
//   //     UserCredential userCredential =
//   //         await FirebaseAuth.instance.signInWithEmailAndPassword(
//   //       email: _email.text,
//   //       password: _password.text,
//   //     );

//   //     DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//   //         .collection('users')
//   //         .doc(userCredential.user?.uid)
//   //         .get();
//   //     SharedPreferences prefs = await SharedPreferences.getInstance();
//   //     prefs.setString('user_uid', userCredential.user?.uid ?? '');
//   //     prefs.setString('user_email', _email.text);

//   //     if (userSnapshot.exists) {
//   //       EasyLoading.showSuccess('Login Successfully!');
//   //       profile.email = _email.text;
//   //       Navigator.pushReplacement(
//   //         context,
//   //         PageRouteBuilder(
//   //           pageBuilder: (context, animation, secondaryAnimation) {
//   //             return const Dashboard();
//   //           },
//   //           transitionDuration: const Duration(seconds: 1),
//   //           transitionsBuilder:
//   //               (context, animation, secondaryAnimation, child) {
//   //             const begin = Offset(10.0, 0.0);
//   //             const end = Offset.zero;
//   //             const curve = Curves.easeInOutQuart;

//   //             var tween =
//   //                 Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//   //             var offsetAnimation = animation.drive(tween);

//   //             return SlideTransition(
//   //               position: offsetAnimation,
//   //               child: child,
//   //             );
//   //           },
//   //         ),
//   //       );
//   //       return;
//   //     } else {
//   //       _showUserNotFoundDialog(context);
//   //       setState(() {
//   //         showCircularProgressIndicator = false;
//   //       });
//   //       return;
//   //     }
//   //   } on FirebaseAuthException catch (e) {
//   //     if (e.code == 'user-not-found' || e.code == 'wrong-password') {
//   //       _showPasswordIncorrectDialog(context);
//   //       setState(() {
//   //         showCircularProgressIndicator = false;
//   //       });
//   //     } else {
//   //       print('Login failed: $e');
//   //       _showUserNotFoundDialog(context);
//   //       setState(() {
//   //         showCircularProgressIndicator = false;
//   //       });
//   //     }
//   //   } catch (e) {
//   //     print('Error: $e');
//   //     setState(() {
//   //       showCircularProgressIndicator = false;
//   //     });
//   //   }
//   // }

//   void authenticateWithFingerprint() async {
//     try {
//       bool isAuthenticated = await auth.authenticate(
//         localizedReason: 'Please authenticate to login',
//         options: const AuthenticationOptions(
//           useErrorDialogs: true,
//           stickyAuth: true,
//         ),
//       );
//       if (isAuthenticated) {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         String? email = prefs.getString('user_email');
//         if (email != null) {
//           profile.email = email;
//           Navigator.pushReplacement(
//             context,
//             PageRouteBuilder(
//               pageBuilder: (context, animation, secondaryAnimation) {
//                 return const Dashboard();
//               },
//               transitionDuration: const Duration(seconds: 1),
//               transitionsBuilder:
//                   (context, animation, secondaryAnimation, child) {
//                 const begin = Offset(10.0, 0.0);
//                 const end = Offset.zero;
//                 const curve = Curves.easeInOutQuart;

//                 var tween = Tween(begin: begin, end: end)
//                     .chain(CurveTween(curve: curve));
//                 var offsetAnimation = animation.drive(tween);

//                 return SlideTransition(
//                   position: offsetAnimation,
//                   child: child,
//                 );
//               },
//             ),
//           );
//         } else {
//           EasyLoading.showError('No email found in shared preferences.');
//         }
//       } else {
//         EasyLoading.showError('Fingerprint authentication failed.');
//       }
//     } catch (e) {
//       print(e);
//       EasyLoading.showError('Fingerprint authentication error: $e');
//     }
//   }

//   void _showPasswordIncorrectDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Alert'),
//           content: const Text('invalid-credential'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showUserNotFoundDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Alert'),
//           content: const Text('Please Enter Correct Email:'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   showCircularProgressIndicator = false;
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
