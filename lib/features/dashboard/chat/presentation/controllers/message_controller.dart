import 'dart:convert';

import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/dashboard/chat/data/models/chat_accept_model.dart';
import 'package:blood_donor/features/dashboard/chat/domain/chat_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MessageController extends GetxController {
  final ChatAcceptModel payload;

  MessageController({required this.payload});
  final ChatRepository _chatRepository = ChatRepository();
  final ScrollController scrollController = ScrollController();
  final TextEditingController message = TextEditingController();
  final FocusNode nosw = FocusNode();
  DateTime now = DateTime.now();
  bool useractive = false;

  int latestMessageId = 0;

  @override
  void onInit() {
    latestMeessageId();
    // getMessagesList(payload.donorId, payload.takerId);

    super.onInit();
  }

  Future<void> latestMeessageId() async {
    latestMessageId = 0;
    latestMessageId = await getLatestMessageID();
    update();
  }

  Future<void> openWhatsApp(String number) async {
    Uri uri = Uri.parse("https://wa.me/$number");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch WhatsApp";
    }
  }

  Future<void> sendNotificationsToUser(String email) async {
    String projectId = 'blood-app-8f4c2';
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = querySnapshot.docs.first;
      String deviceToken = userDoc['deviceToken'];
      String name = userDoc['firstname'] + " " + userDoc['lastname'];

      // Prepare notification data (v1 API format)
      var data = {
        'message': {
          'token': deviceToken,
          'notification': {
            'title': 'new message',
            'body': 'You have a new message from $name',
          },
          'data': {'type': 'chat', 'id': 'Nomi12345'}
        }
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
  }

  Future<int> getLatestMessageID() async {
    try {
      return await _chatRepository.getLatestMessageID();
    } catch (e) {
      Helper.handleError(e, 'Error while getting message id!');
      return 0;
    }
  }

  Stream<QuerySnapshot> getMessagesList(String senderId, String receiverId) {
    try {
      return _chatRepository.getMessagesList(senderId, receiverId);
    } catch (e) {
      Helper.handleError(e, 'Error while getting message list!');
      return Stream.empty();
    }
  }

  Stream<bool> getOnlineOffline(String senderEmail, String receiverEmail) {
    try {
      return _chatRepository.getOnlineOffline(senderEmail, receiverEmail);
    } catch (e) {
      Helper.handleError(e, 'Error while online and offline user!');
      return Stream.value(false);
    }
  }

  Future<void> sendMessage(dynamic payload) async {
    try {
      return await _chatRepository.sendMessage(payload);
    } catch (e) {
      Helper.handleError(e, 'Error while sending message!');
    }
  }
}
