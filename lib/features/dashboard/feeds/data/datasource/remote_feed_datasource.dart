import 'dart:convert';

import 'package:blood_donor/common/widgets/custon_snakbar.dart';
import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/feeds/data/models/chat_request_model.dart';
import 'package:blood_donor/features/dashboard/feeds/data/models/feed_taker_model.dart';
import 'package:blood_donor/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

class RemoteFeedDatasource {
  RemoteFeedDatasource._privateController();
  static final RemoteFeedDatasource _remoteFeedDatasource =
      RemoteFeedDatasource._privateController();
  factory RemoteFeedDatasource() {
    return _remoteFeedDatasource;
  }

  Future<List<FeedTakerModel>> getFeedTakerData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('taker')
          .where('status', isEqualTo: false)
          .get();

      List<FeedTakerModel> takerList = [];

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          if (doc['email'] == UserController.to.userModel!.email) {
            continue;
          } else {
            takerList.add(
                FeedTakerModel.fromJson(doc.data() as Map<String, dynamic>));
          }
        }
      } else {
        showCustomSnackBar(navigatorKey.currentContext!,
            message: 'No data found!');
      }

      return takerList;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> sendChatRequest(dynamic payload) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      final QuerySnapshot senderSnapshot = await _firestore
          .collection('chat_request')
          .where('senderEmail', isEqualTo: payload['senderEmail'])
          .where('recipientEmail', isEqualTo: payload['recipientEmail'])
          .get();

      if (senderSnapshot.docs.isNotEmpty) {
        showCustomSnackBar(navigatorKey.currentContext!,
            message:
                'Already Send Chat Request to ${payload['recipientEmail']}');
        return false;
      }

      await _firestore.collection('chat_request').add(payload);
      showCustomSnackBar(navigatorKey.currentContext!,
          message: 'sending chat request is successfully');
      return true;
    } catch (error) {
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

      for (QueryDocumentSnapshot userDoc in querySnapshot.docs) {
        String name = '${userDoc['firstname']} ${userDoc['lastname']}';

        var data = {
          "message": {
            "token": userDoc['deviceToken'],
            "notification": {
              'title': 'New Blood Request',
              'body': 'You have a new request from $name',
            },
            // "data": {'type': 'request_notification', 'id': 'Nomi12345'}
          }
        };

        var jsonString = await rootBundle.loadString('images/json/key1.json');
        var clientCredentials =
            auth.ServiceAccountCredentials.fromJson(jsonString);

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
          logSuccess('Notification sent successfully to user: ${name}');
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
        // showCustomSnackBar(navigatorKey.currentContext!,
        //     message: 'User not found with email: $email');
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ChatRequestModel>> getChatRequestData() async {
    try {
      List<ChatRequestModel> chatList = [];
      String email = UserController.to.userModel!.email;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('chat_request')
          .where('status', isEqualTo: 'pending')
          .where('recipientEmail', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        chatList = querySnapshot.docs.map((doc) {
          Timestamp? timestamp = doc['timestamp'];
          // DateTime dateTime = timestamp!.toDate();
          // String formattedTime =
          //     DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

          return ChatRequestModel(
            receiverId: doc['receiver_id'],
            senderId: doc['sender_id'],
            senderEmail: doc['senderEmail'],
            name: doc['name'],
            receiverImage: doc['receiverimage'],
            image: doc['image'],
            senderName: doc['senderName'],
            senderNumber: doc['senderNumber'],
            recipientEmail: doc['recipientEmail'],
            recipientNumber: doc['recipientNumber'],
            status: doc['status'],
            timestamp: timestamp,
          );
        }).toList();
      } else {
        showCustomSnackBar(navigatorKey.currentContext!,
            message: 'No pending chat requests found');
      }

      return chatList;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteChatRequest(String email) async {
    try {
      String userEmail = UserController.to.userModel!.email;

      // Query for both sender-recipient combinations
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('chat_request')
          .where('status', isEqualTo: 'pending')
          .where('senderEmail', whereIn: [userEmail, email]).where(
              'recipientEmail',
              whereIn: [userEmail, email]).get();

      if (snapshot.docs.isEmpty) {
        showCustomSnackBar(navigatorKey.currentContext!,
            message: 'No pending requests found!');

        return;
      }

      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var doc in snapshot.docs) {
        // Optional: confirm the direction is correct
        final sender = doc['senderEmail'];
        final recipient = doc['recipientEmail'];
        if ((sender == userEmail && recipient == email) ||
            (sender == email && recipient == userEmail)) {
          batch.delete(doc.reference);
        }
      }

      await batch.commit();

      logSuccess("Pending requests deleted successfully.");
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> deleteRequest(String email) async {
  //   try {
  //     String userEmail = UserController.to.userModel!.email.toString();
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('chat_request')
  //         .where('status', isEqualTo: 'pending')
  //         .where('recipientEmail', isEqualTo: userEmail)
  //         .where('senderEmail', isEqualTo: email)
  //         .get();
  //     QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
  //         .collection('chat_request')
  //         .where('status', isEqualTo: 'pending')
  //         .where('recipientEmail', isEqualTo: email)
  //         .where('senderEmail', isEqualTo: userEmail)
  //         .get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       for (var doc in querySnapshot.docs) {
  //         await FirebaseFirestore.instance
  //             .collection('chat_request')
  //             .doc(doc.id)
  //             .delete();
  //       }
  //       print("Pending requests deleted successfully.");
  //     } else if (querySnapshot1.docs.isNotEmpty) {
  //       for (var doc in querySnapshot1.docs) {
  //         await FirebaseFirestore.instance
  //             .collection('chat_request')
  //             .doc(doc.id)
  //             .delete();
  //       }
  //       print("Pending requests deleted successfully.");
  //     } else {
  //       print("No pending requests found.");
  //     }
  //   } catch (e) {
  //     print('Error updating or deleting user: $e');
  //   }
  // }

  Future<bool> acceptChatRequest(dynamic payload) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('chat_accept')
          .where('donor_email', isEqualTo: payload['donor_email'])
          .where('taker_email', isEqualTo: payload['taker_email'])
          .get();

      QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
          .collection('chat_accept')
          .where('donor_email', isEqualTo: payload['taker_email'])
          .where('taker_email', isEqualTo: payload['donor_email'])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        showCustomSnackBar(navigatorKey.currentContext!,
            message: 'This person is already in chat');
        return false;
      } else if (querySnapshot1.docs.isNotEmpty) {
        showCustomSnackBar(navigatorKey.currentContext!,
            message: 'This person is already in chat');
        return false;
      } else {
        // If senderEmail does not exist, send chat request
        DocumentReference docRef =
            await _firestore.collection('chat_accept').add(payload);
        String documentId = docRef.id;

        await docRef.update({
          'id': documentId,
        });
        showCustomSnackBar(navigatorKey.currentContext!,
            message: 'Chat Accept of ${payload['accepteremail']}');
        aceeptingNotification(payload['donor_email']);

        // // Call function to send request (not sure about this function)
        // AcceptRequest(senderemail);
        return true;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateChatRequest(String senderEmail) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      final QuerySnapshot senderSnapshot = await _firestore
          .collection('chat_request')
          .where('recipientEmail', isEqualTo: senderEmail)
          .get();

      if (senderSnapshot.docs.isNotEmpty) {
        logSuccess(
            'Sender email already exists. Updating status to "accepting"');

        final DocumentReference docRef = senderSnapshot.docs.first.reference;

        await docRef.update({'status': 'accepting'});

        return;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> aceeptingNotification(String email) async {
    try {
      String projectId = 'blood-app-8f4c2';

      // Fetch all users from Firestore who are donors
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      // Iterate over each user document
      for (QueryDocumentSnapshot userDoc in querySnapshot.docs) {
        // Get the device token and email from the user document
        String deviceToken = userDoc['deviceToken'];

        print("Device Token $deviceToken");

        var data = {
          'message': {
            'token': deviceToken,
            'notification': {
              'title': 'Request Accept',
              'body': 'You have in Chat.',
            },
            'data': {'type': 'request_notification', 'id': 'Nomi12345'}
          }
        };

        // Send notification to the device
        var jsonString = await rootBundle.loadString('images/json/key1.json');
        var clientCredentials =
            auth.ServiceAccountCredentials.fromJson(jsonString);

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

        // Check response status
        if (response.statusCode == 200) {
          logSuccess('Notification sent successfully to user: ${userDoc.id}');
        } else {
          logError(
              'Failed to send notification to user: ${userDoc.id}. Status code: ${response.statusCode}');
          logError('Response body: ${response.body}');
        }
      }
    } catch (e) {
      logError('Error sending notification: $e');
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

  Future<void> updateAppStatus(bool isActive) async {
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
            .update({'status': isActive});
      }
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

  //   Future<void> checkAvailabilityDonor() async {
  //   final firestore = FirebaseFirestore.instance;

  //   // Calculate the timestamp for 2 minutes ago
  //   DateTime twoMinutesAgo = DateTime.now().subtract(Duration(minutes: 2));
  //   Timestamp twoMinutesAgoTimestamp = Timestamp.fromDate(twoMinutesAgo);

  //   // Get all donors added more than 2 minutes ago
  //   QuerySnapshot querySnapshot = await firestore
  //       .collection('available_donor')
  //       .where('createdAt', isLessThanOrEqualTo: twoMinutesAgoTimestamp)
  //       .get();

  //   // Update the status of each expired document to 'false'
  //   for (var doc in querySnapshot.docs) {
  //     await firestore.collection('available_donor').doc(doc.id).update({
  //       'status': false,
  //     });
  //   }
  // }
}
