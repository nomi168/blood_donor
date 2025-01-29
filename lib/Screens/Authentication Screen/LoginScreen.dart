// ignore_for_file: file_names, use_build_context_synchronously
import 'package:blood_donor/Json%20Data/GlobalVariable.dart';
import 'package:blood_donor/Screens/Authentication%20Screen/OTPForget.dart';
import 'package:blood_donor/Screens/Authentication%20Screen/SignupScreen.dart';
import 'package:blood_donor/Screens/Main%20Screen/Dashoard/Dashboatd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool showCircularProgressIndicator = false;
  final LocalAuthentication auth = LocalAuthentication();
  bool _isFingerprintAuthenticated = false;
  bool isPasswordVisible = false;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r"^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$")
        .hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    } else if (!RegExp(r"^(?=.*[0-9])(?=.*[!@#$%^&*(),.?\:{}|<>]).*$")
        .hasMatch(value)) {
      return 'Password must contain at least one number and one special character';
    }
    return null;
  }

  bool? _hasBioSensorr;
  LocalAuthentication authentication = LocalAuthentication();
  Future<void> _checkBio() async {
    try {
      _hasBioSensorr = await authentication.canCheckBiometrics;
      print(_hasBioSensorr);
      if (_hasBioSensorr!) {
        _getAuth();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getAuth() async {
    bool isAuth = false;
    try {
      isAuth = await authentication.authenticate(
        localizedReason: 'Scan your fingerprint',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
        ),
      );
      if (isAuth) {
        setState(() async {
          _isFingerprintAuthenticated = true;
          if (_isFingerprintAuthenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
              (Route<dynamic> route) => false, // Remove all existing routes
            );
            /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => mainpage(navigateFrom: "")),
          ); */
          } else {}
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    // _checkBio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0.w, 1.h, 0.w, 0.h),
              child:
                  Center(child: SvgPicture.asset('images/Banners/Login.svg')),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.w, 5.h, 0, 0),
              child: Center(
                child: Text(
                  'Login',
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
              child: Material(
                elevation: 2.5,
                borderRadius: BorderRadius.circular(10.0),
                child: TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    label: const Text(
                      'Email',
                      style: TextStyle(fontSize: 15, color: Colors.black45),
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
                  ),
                  validator: validateEmail,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
              child: Material(
                elevation: 2.5,
                borderRadius: BorderRadius.circular(10.0),
                child: TextFormField(
                  controller: _password,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    label: const Text(
                      'Password',
                      style: TextStyle(fontSize: 15, color: Colors.black45),
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: validatePassword,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(62.w, 0, 0, 0),
              child: TextButton(
                child: Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFDE0A1E),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const OTPForgetScreen();
                      },
                      transitionDuration: const Duration(seconds: 1),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(10.0, 0.0);
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
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 0.h, 5.w, 0),
              child: Material(
                elevation: 3.5,
                shadowColor: Colors.black,
                borderRadius: BorderRadius.circular(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showCircularProgressIndicator = true;
                    });
                    if (_formKey.currentState?.validate() ?? false) {
                      loginToFirestore();
                    } else {
                      setState(() {
                        showCircularProgressIndicator = false;
                      });
                    }
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(vertical: 13.5, horizontal: 0),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFDE0A1E)),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (showCircularProgressIndicator)
                        const SizedBox(
                          height: 22.0,
                          width: 22.0,
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
                          fontSize: 12.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupScreen()));
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(1.w, 2.h, 0, 0),
                    child: Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 12.sp,
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
        ),
      ),
    );
  }

  void loginToFirestore() async {
    final email = _email.text.trim();
    final password = _password.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      EasyLoading.showError('Invalid email format');
      return;
    }
    if (password.isEmpty) {
      EasyLoading.showError('Password cannot be empty');
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_uid', userCredential.user?.uid ?? '');
      prefs.setString('user_email', email);

      if (userSnapshot.exists) {
        EasyLoading.showSuccess('Login Successfully!');
        profile.email = email;
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const Dashboard();
            },
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(10.0, 0.0);
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
        _showUserNotFoundDialog(context);
        setState(() {
          showCircularProgressIndicator = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        _showPasswordIncorrectDialog(context);
      } else {
        print('Login failed: $e');
        _showUserNotFoundDialog(context);
      }
      setState(() {
        showCircularProgressIndicator = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        showCircularProgressIndicator = false;
      });
    }
  }

  // void loginToFirestore() async {
  //   try {
  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: _email.text,
  //       password: _password.text,
  //     );

  //     DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userCredential.user?.uid)
  //         .get();
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString('user_uid', userCredential.user?.uid ?? '');
  //     prefs.setString('user_email', _email.text);

  //     if (userSnapshot.exists) {
  //       EasyLoading.showSuccess('Login Successfully!');
  //       profile.email = _email.text;
  //       Navigator.pushReplacement(
  //         context,
  //         PageRouteBuilder(
  //           pageBuilder: (context, animation, secondaryAnimation) {
  //             return const Dashboard();
  //           },
  //           transitionDuration: const Duration(seconds: 1),
  //           transitionsBuilder:
  //               (context, animation, secondaryAnimation, child) {
  //             const begin = Offset(10.0, 0.0);
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
  //       return;
  //     } else {
  //       _showUserNotFoundDialog(context);
  //       setState(() {
  //         showCircularProgressIndicator = false;
  //       });
  //       return;
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found' || e.code == 'wrong-password') {
  //       _showPasswordIncorrectDialog(context);
  //       setState(() {
  //         showCircularProgressIndicator = false;
  //       });
  //     } else {
  //       print('Login failed: $e');
  //       _showUserNotFoundDialog(context);
  //       setState(() {
  //         showCircularProgressIndicator = false;
  //       });
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     setState(() {
  //       showCircularProgressIndicator = false;
  //     });
  //   }
  // }

  void authenticateWithFingerprint() async {
    try {
      bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      if (isAuthenticated) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? email = prefs.getString('user_email');
        if (email != null) {
          profile.email = email;
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return const Dashboard();
              },
              transitionDuration: const Duration(seconds: 1),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(10.0, 0.0);
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
        } else {
          EasyLoading.showError('No email found in shared preferences.');
        }
      } else {
        EasyLoading.showError('Fingerprint authentication failed.');
      }
    } catch (e) {
      print(e);
      EasyLoading.showError('Fingerprint authentication error: $e');
    }
  }

  void _showPasswordIncorrectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('invalid-credential'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showUserNotFoundDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Please Enter Correct Email:'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  showCircularProgressIndicator = false;
                });
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
