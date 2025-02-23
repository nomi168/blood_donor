import 'package:cloud_firestore/cloud_firestore.dart';

class RemoteAuthDataSource {
  RemoteAuthDataSource._privateController();
  static final RemoteAuthDataSource _remoteAuthDataSource =
      RemoteAuthDataSource._privateController();
  factory RemoteAuthDataSource() {
    return _remoteAuthDataSource;
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<void> addUser(dynamic payload) async {
  //   try {
  //     showLoader("please wait");
  //     CollectionReference users = _firestore.collection('users');
  //     QuerySnapshot existingUsers =
  //         await users.where('email', isEqualTo: payload[email]).get();

  //     if (existingUsers.docs.isNotEmpty) {
  //       _showAlertDialog1(context);
  //       EasyLoading.dismiss();
  //     } else {
  //       UserCredential result = await _auth.createUserWithEmailAndPassword(
  //         email: _email.text.trim(),
  //         password: _password.text.trim(),
  //       );

  //       // String profileImageUrl = widget.image;

  //       // // ignore: unnecessary_null_comparison
  //       // ignore: unnecessary_null_comparison
  //       // if (profileImageUrl != null) {
  //       //   final File imageFile = File(profileImageUrl);

  //       //   final storageRef = FirebaseStorage.instance
  //       //       .ref()
  //       //       .child('profile_images/${result.user?.uid}.jpg');

  //       //   await storageRef.putFile(imageFile);
  //       //   profileImageUrl = await storageRef.getDownloadURL();
  //       // }
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       prefs.setString('user_uid', result.user?.uid ?? '');
  //       prefs.setString('user_email', _email.text.trim());
  //       user_id = result.user!.uid;
  //       // print('Add');

  //       // Store additional user information in Firestore
  //       await _firestore.collection('users').doc(result.user?.uid).set({
  //         'id': result.user?.uid,
  //         'firstname': _fname.text.trim(),
  //         'lastname': _lname.text.trim(),
  //         'deviceToken': token.toString(),
  //         'phonenumber': '0${_phonenumber.text.trim()}',
  //         'email': _email.text.trim(),
  //         'location': _location.text.trim(),
  //         'bloodgroup': selectedIndex1,
  //         'gender': selectedIndex,
  //         'password': _password.text.trim(),
  //         'image': picture1,
  //         'type': 'donor',
  //         'status': false,
  //         'availabledonate': false
  //       });

  //       await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: _email.text.trim(),
  //         password: _password.text.trim(),
  //       );
  //       String name = _fname.text.trim() + " " + _fname.text.trim();
  //       EasyLoading.showSuccess('Create Account Successfully!');
  //       // authBloc.questionresult = true;
  //       // authBloc.notifyListeners();
  //       showCircularProgressIndicator = false;
  //       hidescanning = false;
  //       setState(() {});
  //       Future.delayed(Duration(microseconds: 500), () {
  //         _usereligible();
  //         _userAddLocations(name, _location.text.trim(), picture1);
  //       });
  //       EasyLoading.dismiss();

  //       Navigator.pushReplacement(
  //         context,
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
  //     EasyLoading.dismiss();
  //     // ignore: avoid_print
  //     print("Error in _handleSignup: $error");
  //     setState(() {
  //       showCircularProgressIndicator = false;
  //       EasyLoading.showError(
  //           "The email address is already in use by another account");
  //     });
  //   }
  // }
}
