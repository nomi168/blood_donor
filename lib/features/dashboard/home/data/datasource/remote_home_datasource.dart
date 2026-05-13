import 'dart:convert';

import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/home/data/models/active_user_model.dart';
import 'package:blood_donor/features/dashboard/home/data/models/banner_model.dart';
import 'package:blood_donor/features/dashboard/home/data/models/blood_bank_model.dart';
import 'package:blood_donor/features/dashboard/home/data/models/donor_accept_model.dart';
import 'package:blood_donor/features/dashboard/home/data/models/donor_update_location_model.dart';
import 'package:blood_donor/features/dashboard/home/data/models/taker_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

class RemoteHomeDatasource {
  RemoteHomeDatasource._privateController();
  static final RemoteHomeDatasource _homeDatasource =
      RemoteHomeDatasource._privateController();
  factory RemoteHomeDatasource() {
    return _homeDatasource;
  }

  Future<List<FeedTakerModel>> getTakersList() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('taker')
          .where('status', isEqualTo: false)
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

      DateTime ninetyDaysAgo =
          DateTime.now().subtract(const Duration(days: 90));
      Timestamp ninetyDaysAgoTimestamp = Timestamp.fromDate(ninetyDaysAgo);

      // Get all donors added more than 90 days ago
      QuerySnapshot querySnapshot = await firestore
          .collection('available_donor')
          .where('email', isEqualTo: UserController.to.userModel!.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        if (userDoc.data() != null && userDoc['createdAt'] != null) {
          Timestamp createdAt = userDoc['createdAt'];

          // Compare only the date (ignoring time part)
          DateTime createdDate = createdAt.toDate();
          DateTime checkDate = ninetyDaysAgoTimestamp.toDate();

          if (createdDate.year == checkDate.year &&
              createdDate.month == checkDate.month &&
              createdDate.day == checkDate.day) {
            // ✅ Update status
            await firestore
                .collection('available_donor')
                .doc(userDoc.id)
                .update({
              'status': true,
            });
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DonateAcceptModel?> getAcceptanceDonor() async {
    try {
      String userEmail = UserController.to.userModel!.email;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('donor_email', isEqualTo: userEmail)
          .where('is_delete', isEqualTo: false)
          .where('taker_received_status', isEqualTo: false)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return DonateAcceptModel.fromJson(data);
      } else {
        // No document found
        return null;
      }
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

  Future<DonateAcceptModel?> seeTakerAcceptanceData() async {
    try {
      String userEmail = UserController.to.userModel!.email;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('email', isEqualTo: userEmail)
          .where('is_delete', isEqualTo: false)
          .where('received_status', isEqualTo: false)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return DonateAcceptModel.fromJson(data);
      } else {
        return null; // No record found
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> aceeptDonationRequest(Map<String, dynamic> payload) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('donor_email', isEqualTo: payload['donor_email'])
          .where('is_delete', isEqualTo: false)
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

  Future<bool> deleteAcceptedRequest(Map<String, dynamic> payload) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('donor_email', isEqualTo: payload['donor_email'])
          .where('email', isEqualTo: payload['email'])
          .where('is_delete', isEqualTo: false)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        await FirebaseFirestore.instance
            .collection('acceptdonation')
            .doc(userDoc.id)
            .update(payload);
        return true;
      } else {
        // Get.snackbar(
        //   "Error",
        //   "No Cancel Request Accepted",
        //   snackPosition: SnackPosition.TOP,
        //   snackStyle: SnackStyle.FLOATING,
        //   backgroundColor: Colors.red.withValues(alpha: 0.9),
        //   colorText: Colors.white,
        //   margin: EdgeInsets.all(10),
        //   duration: Duration(seconds: 3),
        //   borderRadius: 8,
        //   icon: Icon(Icons.error, color: Colors.white),
        // );

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

  Future<bool> updateReceivedStatue(String id) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('id', isEqualTo: id)
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
        return true;
      } else {
        return false;
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
          'status': false,
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

  Future<void> updateDonorStatus(String id) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('id', isEqualTo: id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document reference
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String documentId = documentSnapshot.id;

        // Update the data in the document
        await FirebaseFirestore.instance
            .collection('acceptdonation')
            .doc(documentId)
            .update({'is_delete': true});
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
      for (var doc in querySnapshot.docs) 
      {
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

  Future<List<BloodBank>> getBloodBanks() async {
    try {
      List<BloodBank> userList = [];
      QuerySnapshot chatQuerySnapshot = await FirebaseFirestore.instance
          .collection('blood_bank')
          .where('availability', isEqualTo: true)
          .get();

      if (chatQuerySnapshot.docs.isNotEmpty) {
        for (var doc in chatQuerySnapshot.docs) {
          userList.add(BloodBank.fromMap((doc.data() as Map<String, dynamic>)));
        }
      } else {
        logError('data not found!');
      }
      return userList;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addBloodBankDonor(dynamic payload) async {
    try {
      final data = await FirebaseFirestore.instance
          .collection('blood_bank_donation')
          .add(payload);

      await data.update({'id': data.id});

      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> checkUserCnicVerification() async {
    try {
      String userEmail = UserController.to.userModel!.email;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('card_scanning_users')
          .where('email', isEqualTo: userEmail)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendLocationToApi(Map<String, dynamic> payload) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      // Check if the email already exists
      QuerySnapshot querySnapshot = await _firestore
          .collection('acceptdonation_location')
          .where('id', isEqualTo: payload['id'])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Email exists, update the document
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;

        await _firestore
            .collection('acceptdonation_location')
            .doc(docSnapshot.id)
            .update({
          'latitude': payload['latitude'],
          'longitude': payload['longitude']
        });

        logSuccess('Donor status updated');
      } else {
        // Email does not exist, create a new document
        await _firestore.collection('acceptdonation_location').add(payload);
      }
    } catch (error) {
      rethrow;
    }
  }

  Stream<LocationUpdateModel?> streamDonorUpdateLocation(String id) {
    try {
      return FirebaseFirestore.instance
          .collection('acceptdonation_location')
          .where('id', isEqualTo: id)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final docData = snapshot.docs.first.data();
          return LocationUpdateModel.fromJson(docData);
        } else {
          return null;
        }
      });
    } catch (e) {
      logError('Error streaming donor location: $e');
      rethrow;
    }
  }

  Future<void> expiredAcceptedRequests() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final userEmail = UserController.to.userModel!.email;

      // Get current time and calculate 24 hours ago
      final now = DateTime.now();
      final twentyFourHoursAgo = now.subtract(const Duration(hours: 24));

      // Fetch accepted requests for this donor
      final querySnapshot = await firestore
          .collection('acceptdonation')
          .where('donor_email', isEqualTo: userEmail)
          .where('is_delete', isEqualTo: false)
          .get();

      if (querySnapshot.docs.isEmpty) return;

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        DateTime? requestDateTime;

        if (data['accept_date'] != null && data['accept_time'] != null) {
          try {
            final String dateStr = data['accept_date']; // e.g. 2025-06-12
            final String timeStr = data['accept_time']; // e.g. 07:22 PM

            // Combine and parse AM/PM time correctly
            final String combined = "$dateStr $timeStr";
            final DateFormat formatter = DateFormat("yyyy-MM-dd hh:mm a");
            requestDateTime = formatter.parse(combined);
          } catch (e) {
            logError("⚠️ Date parsing error for doc ${doc.id}: $e");
          }
        }

        if (requestDateTime == null) continue;

        // ✅ Compare if request older than 24 hours
        if (requestDateTime.isBefore(twentyFourHoursAgo)) {
          await firestore
              .collection('acceptdonation')
              .doc(doc.id)
              .update({'is_delete': true});
          logSuccess("🗑 Deleted expired request: ${doc.id}");
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkIsNextProcess(String id) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('id', isEqualTo: id)
          .where('status', isEqualTo: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Stream<bool> checkIsNextProcessRealTime(String id) {
    try {
      return FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('id', isEqualTo: id)
          .snapshots()
          .map((snapshot) {
        // When any doc changes in real time, this is re-triggered
        if (snapshot.docs.isNotEmpty) {
          final doc = snapshot.docs.first;
          return doc['status'] == true;
        }
        return false;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateAcceptanceData(String id) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('id', isEqualTo: id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document reference
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String documentId = documentSnapshot.id;
        if (UserController.to.userModel!.type == 'taker') {
          await FirebaseFirestore.instance
              .collection('acceptdonation')
              .doc(documentId)
              .update({'is_delete': true, 'received_status': true});
        } else {
          await FirebaseFirestore.instance
              .collection('acceptdonation')
              .doc(documentId)
              .update({'is_delete': true, 'taker_received_status': true});
        }

        // Update the data in the document
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getCurrentDonorLocation(String id) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        String userId = data['id']!.toString();
        if (userId.isNotEmpty) {
          QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
              .collection('donor_location')
              .where('user_id', isEqualTo: userId)
              .get();
          var data = querySnapshot1.docs.first.data() as Map<String, dynamic>;
          return data['donor_location']?.toString();
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendNotification(String email) async {
    try {
      String projectId = 'blood-app-8f4c2';

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        String deviceToken = userDoc['deviceToken'];

        var data = {
          'message': {
            'token': deviceToken,
            'notification': {
              'title': 'Blood Request Accepted',
              'body':
                  'Good news! ${UserController.to.userModel!.firstname} ${UserController.to.userModel!.lastname} has accepted your blood request.',
            },
            'android': {
              'priority': 'HIGH', // ✅ Correct place for priority
              'notification': {
                'sound': 'custom_sound', // ✅ Do NOT include .wav extension
                'default_vibrate_timings': true,
                'icon': 'ic_blood_request', // Optional custom icon name
                'color': '#DE0A1E',
              },
            },
            'apns': {
              'payload': {
                'aps': {
                  'sound': 'custom_sound.wav',
                  'alert': {
                    'title': 'Blood Request Accepted',
                    'body':
                        'Good news! ${UserController.to.userModel!.firstname} ${UserController.to.userModel!.lastname} has accepted your blood request.',
                  },
                },
              },
            },
            'data': {
              'type': 'blood_accept_notification',
              'id': 'Nomi12345',
            },
          },
        };

        // Generate OAuth2 token using service account
        var jsonString = await rootBundle.loadString('images/json/key1.json');
        var clientCredentials =
            auth.ServiceAccountCredentials.fromJson(jsonString);
        // var clientCredentials = auth.ServiceAccountCredentials.fromJson(
        //     await File('images/json/key.json').readAsString());
        var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
        var client =
            await auth.clientViaServiceAccount(clientCredentials, scopes);

        var response = await http.post(
          Uri.parse(
              'https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
          headers: {
            'Authorization': 'Bearer ${client.credentials.accessToken.data}',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          logSuccess('Notification sent successfully to user: ${userDoc.id}');
        } else {
          logError(
              'Failed to send notification to user: ${userDoc.id}. Status code: ${response.statusCode}');
          logError('Response body: ${response.body}');
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
