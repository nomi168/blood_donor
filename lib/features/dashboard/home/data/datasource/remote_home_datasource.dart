import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/home/data/models/active_user_model.dart';
import 'package:blood_donor/features/dashboard/home/data/models/banner_model.dart';
import 'package:blood_donor/features/dashboard/home/data/models/donor_accept_model.dart';
import 'package:blood_donor/features/dashboard/home/data/models/taker_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RemoteHomeDatasource {
  RemoteHomeDatasource._privateController();
  static final RemoteHomeDatasource _homeDatasource =
      RemoteHomeDatasource._privateController();
  factory RemoteHomeDatasource() {
    return _homeDatasource;
  }

  Future<List<FeedTakerModel>> getTakersList() async {
    try {
      String blood = UserController.to.userModel!.bloodgroup;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('taker')
          .where('status', isEqualTo: false)
          .where('blood', isEqualTo: blood)
          .get();

      List<FeedTakerModel> takerList = [];

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          takerList
              .add(FeedTakerModel.fromJson(doc.data() as Map<String, dynamic>));
        }
      } else {
        // showCustomSnackBar(navigatorKey.currentContext!,
        //     message: 'No data found!');
      }
      return takerList;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDonorLocation(String location, String userID) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('donor_location')
          .where('user_id', isEqualTo: userID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String documentId = documentSnapshot.id;

        await FirebaseFirestore.instance
            .collection('donor_location')
            .doc(documentId)
            .update({'donor_location': location});
      } else {
        logError('User not found with email:');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateFCMToken(String userId, String token) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String documentId = documentSnapshot.id;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(documentId)
            .update({'deviceToken': token});

        logSuccess('Data updated successfully in users table');
      } else {
        logError('User not found with email:');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> checkAvailabilityDonor() async {
    try {
      final firestore = FirebaseFirestore.instance;

      DateTime ninetyDaysAgo = DateTime.now().subtract(Duration(days: 90));
      Timestamp ninetyDaysAgoTimestamp = Timestamp.fromDate(ninetyDaysAgo);

      // Get all donors added more than 90 days ago
      QuerySnapshot querySnapshot = await firestore
          .collection('available_donor')
          .where('createdAt', isLessThanOrEqualTo: ninetyDaysAgoTimestamp)
          .get();

      // Update the status of each expired document to 'false'
      for (var doc in querySnapshot.docs) {
        await firestore.collection('available_donor').doc(doc.id).update({
          'status': false,
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DonateAcceptModel>> getAcceptanceDonor() async {
    try {
      List<DonateAcceptModel> donorList = [];
      String userEmail = UserController.to.userModel!.email;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('donor_email', isEqualTo: userEmail)
          .where('status', isEqualTo: false)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          donorList.add(
              DonateAcceptModel.fromJson(doc.data() as Map<String, dynamic>));
        }
      } else {
        // showCustomSnackBar(navigatorKey.currentContext!,
        //     message: 'No data found!');
      }
      return donorList;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateStatus(bool status) async {
    try {
      String userEmail = UserController.to.userModel!.email;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String userId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'status': status});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool?> getavailableDonor(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('available_donor')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        bool status = userDoc['status'];
        return status;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DonateAcceptModel>> seeTakerAcceptanceData() async {
    try {
      List<DonateAcceptModel> seeList = [];
      String userEmail = UserController.to.userModel!.email;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('email', isEqualTo: userEmail)
          .where('status', isEqualTo: false)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          seeList.add(
              DonateAcceptModel.fromJson(doc.data() as Map<String, dynamic>));
        }
      } else {
        // showCustomSnackBar(navigatorKey.currentContext!,
        //     message: 'No data found!');
      }
      return seeList;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> aceeptDonationRequest(dynamic payload) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('takerid', isEqualTo: payload['takerid'])
          .get();

      if (querySnapshot.docs.isEmpty) {
        DocumentReference docRef =
            await _firestore.collection('acceptdonation').add(payload);
        String documentId = docRef.id;

        await docRef.update({
          'id': documentId,
        });
        return true;
      } else {
        return false;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteAcceptedRequest(dynamic payload) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('donor_email', isEqualTo: payload['donor_email'])
          .where('email', isEqualTo: payload['email'])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        await FirebaseFirestore.instance
            .collection('acceptdonation')
            .doc(userDoc.id)
            .delete();
        return true;
      } else {
        Get.snackbar(
          "Error",
          "No Cancel Request Accepted",
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
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> getReceivedStatus(Map<String, dynamic> payload) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('donor_email', isEqualTo: payload['donor_email'])
          .where('email', isEqualTo: payload['email'])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        if (userDoc['received_status'] == true) {
          return true;
        }
      } else {
        logError('No documents found in the acceptdonation collection');
      }
    } catch (e) {
      rethrow;
    }

    return false;
  }

  Future<bool> getTakerReceivedStatus(String email, String donorEmall) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('donor_email', isEqualTo: donorEmall)
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        if (userDoc.exists && userDoc['taker_received_status'] == true) {
          return true;
        }
      } else {
        logError('No documents found in the acceptdonation collection');
      }
    } catch (e) {
      rethrow;
    }

    return false;
  }

  Future<String?> getDonorCurrentLocation(String donorEmail) async {
    try {
      // Step 1: Fetch user document ID based on email
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: donorEmail)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        logError('User not found');
        return null;
      }

      String userId = userSnapshot.docs.first.id;

      QuerySnapshot locationSnapshot = await FirebaseFirestore.instance
          .collection('donor_location')
          .where('user_id', isEqualTo: userId)
          .limit(1)
          .get();

      if (locationSnapshot.docs.isNotEmpty) {
        return locationSnapshot.docs.first['donor_location'] as String?;
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateReceivedStatue(
      String takerEmail, String donorEmail) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('email', isEqualTo: takerEmail)
          .where('donor_email', isEqualTo: donorEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document reference
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String documentId = documentSnapshot.id;

        // Update the data in the document
        await FirebaseFirestore.instance
            .collection('acceptdonation')
            .doc(documentId)
            .update({'received_status': true});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTakerReceivedStatue(
      String takerEmail, String donorEmail) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('email', isEqualTo: takerEmail)
          .where('donor_email', isEqualTo: donorEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document reference
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String documentId = documentSnapshot.id;

        // Update the data in the document
        await FirebaseFirestore.instance
            .collection('acceptdonation')
            .doc(documentId)
            .update({'taker_received_status': true});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<double?> getDonorRating(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('donorrating')
          .where('donor_email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        String userId = userDoc['rating'];
        return double.parse(userId);
      } else {
        logError('No documents found in the Request collection');
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<void> addOrUpdateAvailableDonor() async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      // Check if the email already exists
      QuerySnapshot querySnapshot = await _firestore
          .collection('available_donor')
          .where('email', isEqualTo: UserController.to.userModel!.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Email exists, update the document
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;

        await _firestore
            .collection('available_donor')
            .doc(docSnapshot.id)
            .update({
          'status': true,
          'createdAt': FieldValue.serverTimestamp(),
        });

        logSuccess('Donor status updated');
      } else {
        // Email does not exist, create a new document
        await _firestore.collection('available_donor').add({
          'email': UserController.to.userModel!.email,
          'status': true,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> addDonorHistory(dynamic payload) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      await _firestore.collection('history').add(payload);
      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateDonorStatus(String takerID, String donorID) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('email', isEqualTo: takerID)
          .where('donor_email', isEqualTo: donorID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document reference
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String documentId = documentSnapshot.id;

        // Update the data in the document
        await FirebaseFirestore.instance
            .collection('acceptdonation')
            .doc(documentId)
            .update({'status': true});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateAcceptDonationData(Map<String, dynamic> payload) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('donorrating')
          .doc(payload['donor_email'])
          .get();

      if (documentSnapshot.exists) {
        await FirebaseFirestore.instance
            .collection('donorrating')
            .doc()
            .update({
          'rating': payload['rating'],
          'review': payload['review'],
        });

        return true;
      } else {
        await FirebaseFirestore.instance.collection('donorrating').add(payload);
        return true;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTakerStatus(
    String takerID,
  ) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('taker')
          .where('taker_id', isEqualTo: takerID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document reference
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String documentId = documentSnapshot.id;

        // Update the data in the document
        await FirebaseFirestore.instance
            .collection('taker')
            .doc(documentId)
            .update({'status': true});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteExpiredRequests() async {
    try {
      dynamic payload = {'status': true};
      final firestore = FirebaseFirestore.instance;
      // Calculate the timestamp for 24 hours ago
      DateTime twentyFourHoursAgo =
          DateTime.now().subtract(Duration(hours: 24));
      Timestamp twentyFourHoursAgoTimestamp =
          Timestamp.fromDate(twentyFourHoursAgo);

      // Get all requests older than 24 hours
      QuerySnapshot querySnapshot = await firestore
          .collection('taker')
          .where('createdAt', isLessThanOrEqualTo: twentyFourHoursAgoTimestamp)
          .get();

      // Delete each expired document
      for (var doc in querySnapshot.docs) {
        await firestore.collection('taker').doc(doc.id).update(payload);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DonateAcceptModel?> getSingleDonorAcceptance(
      String takerEmail, String donorEmail) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('donor_email', isEqualTo: donorEmail)
          .where('email', isEqualTo: takerEmail)
          .where('status', isEqualTo: false)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return DonateAcceptModel.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>,
        );
      } else {
        // showCustomSnackBar(
        //   navigatorKey.currentContext!,
        //   message: 'No data found!',
        // );
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ActiveUserModel>> getTodayActiveUsers() async {
    try {
      List<ActiveUserModel> userList = [];

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('active_users')
          .where('email', isEqualTo: UserController.to.userModel!.email)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        userList.add(ActiveUserModel.fromJson(data));
      }

      return userList;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addTodateActiveUser(dynamic payload) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      await _firestore.collection('active_users').add(payload);
    } catch (error) {
      rethrow;
    }
  }

  Future<int?> getDonorBloodCount() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: UserController.to.userModel!.email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        int bloodCount = snapshot.docs.first['blood_count'];
        return bloodCount;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDonorBloodCount(int count) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: UserController.to.userModel!.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document reference
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String documentId = documentSnapshot.id;

        // Update the data in the document
        await FirebaseFirestore.instance
            .collection('users')
            .doc(documentId)
            .update({'blood_count': count});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkTakerBloodRequest(Map<String, dynamic> payload) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('taker')
          .where('status', isEqualTo: false)
          .where('email', isEqualTo: payload['email'])
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

  Future<List<BannerModel>> getBanners() async {
    try {
      List<BannerModel> bannerList = [];
      QuerySnapshot chatQuerySnapshot = await FirebaseFirestore.instance
          .collection('banners')
          .orderBy('id', descending: false)
          .get();

      if (chatQuerySnapshot.docs.isNotEmpty) {
        for (var doc in chatQuerySnapshot.docs) {
          bannerList
              .add(BannerModel.fromJson((doc.data() as Map<String, dynamic>)));
        }
      } else {
        logError('data not found!');
      }
      return bannerList;
    } catch (e) {
      rethrow;
    }
  }

  Future<FeedTakerModel?> checkTakerCondition() async {
    try {
      String email = UserController.to.userModel!.email;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('taker')
          .where('status', isEqualTo: false)
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return FeedTakerModel.fromJson(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
