import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/auth/data/models/user_model.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteAuthDataSource {
  RemoteAuthDataSource._privateController();
  static final RemoteAuthDataSource _remoteAuthDataSource =
      RemoteAuthDataSource._privateController();
  factory RemoteAuthDataSource() {
    return _remoteAuthDataSource;
  }

  Future<bool> checkEmail(String email) async {
    // final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    CollectionReference users = _firestore.collection('users');

    try {
      QuerySnapshot existingUsers =
          await users.where('email', isEqualTo: email).get();

      if (existingUsers.docs.isEmpty) {
        // Email exists in Firestore
        logError("Email found in Firestore users collection.");

        return true;
      }
      else {
        return false;
      }

      // // Check if email exists in Firebase Authentication
      // List<String> signInMethods =
      //     // ignore: deprecated_member_use
      //     await _auth.fetchSignInMethodsForEmail(email);

      // if (signInMethods.isNotEmpty) {
      //   return false;
      // }

      
    } catch (error) {
      rethrow;
    }

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

  Future<void> userAddLocation(String id, String name, String location) async {
    try {
      // Store additional user information in Firestore
      await FirebaseFirestore.instance.collection('donor_location').add({
        'user_id': id,
        'donor_name': name,
        'donor_location': location,
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> usereligible(String id, {bool flag = false}) async {
    try {
      await FirebaseFirestore.instance.collection('terms_condition').add({
        'user_id': id,
        'donation_process': flag ? true : false,
        'eligibility': flag ? true : false,
        'hygiene': flag ? true : false,
        'safety': flag ? true : false,
        'privacy_policy': flag ? true : false
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> addUser(Map<String,dynamic> paylaod, {bool flag = false}) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      QuerySnapshot existingUsers =
          await users.where('email', isEqualTo: paylaod['email']).get();

      if (existingUsers.docs.isNotEmpty) {
        Get.snackbar(
          "Error",
          "email is already exist, please try another email!",
          snackPosition: SnackPosition.TOP,
          snackStyle: SnackStyle.FLOATING,
          backgroundColor: Colors.red.withValues(alpha: 0.9),
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 3),
          borderRadius: 8,
          icon: Icon(Icons.error, color: Colors.white),
        );

        return false;
      } else {
        final Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('profile_images/${DateTime.now()}.jpg');

        final UploadTask uploadTask =
            storageReference.putFile(paylaod['image']);
        await uploadTask.whenComplete(() => null);

        final imageUrl = await storageReference.getDownloadURL();
        paylaod['image'] = imageUrl;
        paylaod;

        UserCredential result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: paylaod['email'], password: paylaod['password']);
        paylaod['id'] = result.user?.uid;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(result.user?.uid)
            .set(paylaod);
        paylaod;
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: paylaod['email'], password: paylaod['password']);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_uid', result.user?.uid ?? '');
        prefs.setString('user_email', paylaod['email']);
        Get.snackbar(
          "Success",
          "add user successfully!",
          snackPosition: SnackPosition.TOP,
          snackStyle: SnackStyle.FLOATING,
          backgroundColor: Colors.green.withValues(alpha: 0.9),
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 3),
          borderRadius: 8,
          icon: Icon(Icons.check_circle, color: Colors.white),
        );

        await Get.put(UserController(), permanent: true);
        // UserController.to.userModel = result;
        // UserController.to.isUserData = true;
        // controller.update();

        return true;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> checkingCNIC(String cnic) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('card_scanning_users')
          .where('card_number', isEqualTo: cnic)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addCnicCardDetail(dynamic payload) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      // Store additional user information in Firestore
      await _firestore.collection('card_scanning_users').add(payload);

      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<UserModel?> loginToFirestore(String email, String password) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final user = UserModel.fromJson(
          querySnapshot.docs.first.data(),
        );
        return user;
      } else {
        Get.snackbar(
          "Error",
          "Email or password is incorrect!",
          snackPosition: SnackPosition.TOP,
          snackStyle: SnackStyle.FLOATING,
          backgroundColor: Colors.red.withValues(alpha: 0.9),
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 3),
          borderRadius: 8,
          icon: Icon(Icons.error, color: Colors.white),
        );

        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  // Future<bool> loginToFirestore(String email, String password) async {
  //   try {
  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userCredential.user?.uid)
  //         .get();

  //     if (userSnapshot.exists) {
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       prefs.setString('user_uid', userCredential.user?.uid ?? '');
  //       prefs.setString('user_email', email);
  //       return true;
  //     } else {
  //       showCustomSnackBar(navigatorKey.currentContext!,
  //           message: "user not found!", color: backgroundColorError);
  //       return false;
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<UserModel?> forgotPassword(Map<String,dynamic> payload) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: payload['email'],
      );

      CollectionReference users = firestore.collection('users');
      QuerySnapshot existingUsers =
          await users.where('email', isEqualTo: payload['email']).get();

      if (existingUsers.docs.isNotEmpty) {
        // User found, update password
        DocumentSnapshot userDoc = existingUsers.docs.first;
        String userId = userDoc.id;

        await users.doc(userId).update({
          'password': payload['password']
          // replace _newPassword with your password variable
        });
         DocumentSnapshot updatedDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        // ✅ Convert to UserModel
        UserModel updatedUser =
            UserModel.fromJson(updatedDoc.data() as Map<String, dynamic>);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_email', payload['email']);
        Get.put(UserController(), permanent: true);
        prefs.setString('user_uid', userDoc.id);
        return updatedUser;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getUserDataByEmail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userEmail = prefs.getString('user_email');
      

      if (userEmail == null || userEmail.isEmpty) {
        // Get.snackbar(
        //   "Error",
        //   "User email not found in local storage.",
        //   snackPosition: SnackPosition.TOP,
        //   snackStyle: SnackStyle.FLOATING,
        //   backgroundColor: Colors.red.withValues(alpha: 0.9),
        //   colorText: Colors.white,
        //   margin: EdgeInsets.all(10),
        //   duration: Duration(seconds: 3),
        //   borderRadius: 8,
        //   icon: Icon(Icons.error, color: Colors.white),
        // );

        return null;
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isEmpty) {
        Get.snackbar(
          "Error",
          "User not found!",
          snackPosition: SnackPosition.TOP,
          snackStyle: SnackStyle.FLOATING,
          backgroundColor: Colors.red.withValues(alpha: 0.9),
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 3),
          borderRadius: 8,
          icon: Icon(Icons.error, color: Colors.white),
        );

        return null;
      }

      final userDoc = querySnapshot.docs.first.data();
      return UserModel.fromJson(userDoc);
    } catch (e) {
      logError('getUserDataByEmail error: $e');
      rethrow;
    }
  }

  Future<void> updateAppStatus(bool isActive) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: UserController.to.userModel!.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String userId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'status': isActive});
      }
    } catch (e) {
      rethrow;
    }
  }
}
