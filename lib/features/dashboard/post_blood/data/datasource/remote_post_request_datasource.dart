import 'dart:io';

import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/auth/data/models/user_model.dart';
import 'package:blood_donor/features/dashboard/post_blood/data/models/user_location_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RemotePostRequestDatasource {
  RemotePostRequestDatasource._privateController();
  static final RemotePostRequestDatasource _postRequestDatasource =
      RemotePostRequestDatasource._privateController();
  factory RemotePostRequestDatasource() {
    return _postRequestDatasource;
  }

  Future<bool> postBloodRequest(Map<String, dynamic> payload) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      if (payload['blood_image'] != null && payload['blood_image'].isNotEmpty) {
        final file1 = File(payload['blood_image']);
        logSuccess("File is $file1");

        if (await file1.exists()) {
          String bloodName = payload['name'] + '.jpg';

          final Reference storageReference =
              FirebaseStorage.instance.ref().child('blood_images/$bloodName');

          final uploadTask = storageReference.putFile(file1);
          await uploadTask.whenComplete(() => null);

          final imageUrl = await storageReference.getDownloadURL();

          payload['blood_image'] = imageUrl;
        } else {
          logError("Error: File at '${payload['image']}' doesn't exist.");
          // Show an error message to the user
        }
      } else {
        // Handle case where picture path is null or empty
        logError("Error: Picture path is null or empty.");
      }
      payload['createdAt'] = FieldValue.serverTimestamp();

      DocumentReference docRef =
          await _firestore.collection('taker').add(payload);
      String documentId = docRef.id;

      await docRef.update({
        'taker_id': documentId,
      });
      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<UserModel>> getUserData(String blood) async {
    try {
      List<UserModel> userList = [];
      QuerySnapshot chatQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('type', isEqualTo: 'donor')
          .where('bloodgroup', isEqualTo: blood)
          .get();

      if (chatQuerySnapshot.docs.isNotEmpty) {
        for (var doc in chatQuerySnapshot.docs) {
          userList
              .add(UserModel.fromJson((doc.data() as Map<String, dynamic>)));
        }
      } else {
        logError('data not found!');
      }
      return userList;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserLocationModel>> getDonorLocations() async {
    try {
      List<UserLocationModel> userLocationList = [];

      QuerySnapshot chatQuerySnapshot =
          await FirebaseFirestore.instance.collection('donor_location').get();

      if (chatQuerySnapshot.docs.isNotEmpty) {
        for (var doc in chatQuerySnapshot.docs) {
          userLocationList.add(
              UserLocationModel.fromJson((doc.data() as Map<String, dynamic>)));
        }
      } else {
        logError('data not found!');
      }

      return userLocationList;
    } catch (e) {
      rethrow;
    }
  }
}
