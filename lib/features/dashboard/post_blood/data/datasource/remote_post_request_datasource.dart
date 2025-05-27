import 'dart:io';

import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class RemotePostRequestDatasource {
  RemotePostRequestDatasource._privateController();
  static final RemotePostRequestDatasource _postRequestDatasource =
      RemotePostRequestDatasource._privateController();
  factory RemotePostRequestDatasource() {
    return _postRequestDatasource;
  }

  Future<bool> postBloodRequest(dynamic payload) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      if (payload['image'] != null && payload['image'].isNotEmpty) {
        // Assuming picture is a path from a file picker
        final file = File(payload['image']);
        logSuccess("File is $file");

        if (await file.exists()) {
          String fileName =
              DateFormat('yyyyMMdd_HHmmss').format(DateTime.now()) + '.jpg';
          final storageRef =
              FirebaseStorage.instance.ref().child('profile_images/$fileName');

          // Upload the file to Firebase Storage
          await storageRef.putFile(file);
          // String profileImageUrl = await storageRef.getDownloadURL();
          // payload['image'] = profileImageUrl;
        } else {
          logError("Error: File at '${payload['image']}' doesn't exist.");
          // Show an error message to the user
        }
      } else {
        // Handle case where picture path is null or empty
        logError("Error: Picture path is null or empty.");
      }
      payload['createdAt'] = FieldValue.serverTimestamp();
      payload;
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
}
