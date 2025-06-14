import 'dart:io';

import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/account/data/models/history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class RemoteAccountDatasource {
  RemoteAccountDatasource._privateController();
  static final RemoteAccountDatasource _accountDatasource =
      RemoteAccountDatasource._privateController();
  factory RemoteAccountDatasource() {
    return _accountDatasource;
  }
  Future<bool> checkDonorAvailability(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('available_donor')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        return userDoc['status'];
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DateTime?> getDonorBackToDonate(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('available_donor')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        Timestamp createdAt = userDoc['createdAt'];
        DateTime createdAtDateTime = createdAt.toDate();

        return createdAtDateTime.add(Duration(days: 90));
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateUserType(String userType, String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String documentId = querySnapshot.docs.first.id;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(documentId)
            .update({
          'type': userType,
        });

        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkingDonorSwitcher(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('donor_switcher')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return true;
      }
      return false;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> addingDonorSwitcher(String email) async {
    try {
      await FirebaseFirestore.instance.collection('donor_switcher').add({
        'email': email,
        'status': true,
      });

      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> addHomeAddress(dynamic payload) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      await _firestore.collection('useraddress').add(payload);
      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> addWorkAddress(dynamic payload) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      await _firestore.collection('useraddress').add(payload);

      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> addTravelAddress(dynamic payload) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      await _firestore.collection('useraddress').add(payload);

      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<BloodHistoryModel>> getHistoryList(
      String email, String type) async {
    try {
      List<BloodHistoryModel> historyLogData = [];

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('history')
          .where(type == 'donor' ? 'donoremail' : 'takeremail',
              isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var element in querySnapshot.docs) {
          historyLogData.add(BloodHistoryModel.fromMap(
              element.data() as Map<String, dynamic>));
        }
      }

      return historyLogData;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> payload) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: UserController.to.userModel!.id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String documentId = documentSnapshot.id;

        // If payload['image'] is a valid file path and the file exists, upload it
        final String imagePath = payload['image'];
        if (!imagePath.startsWith('http')) {
          final File imageFile = File(imagePath);

          if (imageFile.existsSync()) {
            final storageRef = FirebaseStorage.instance
                .ref()
                .child('profile_images/${UserController.to.userModel!.id}.jpg');

            await storageRef.putFile(imageFile);
            String imageUrl = await storageRef.getDownloadURL();
            payload['image'] = imageUrl;
          } else {
            debugPrint("❌ Image file does not exist at: $imagePath");
            // You can also choose to remove it from payload or handle differently
            return false;
          }
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(documentId)
            .update(payload);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("❌ Update Profile Error: $e");
      rethrow;
    }
  }
}
