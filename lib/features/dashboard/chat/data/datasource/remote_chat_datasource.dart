import 'package:async/async.dart';
import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/chat/data/models/chat_accept_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RemoteChatDatasource {
  RemoteChatDatasource._privateController();
  static final RemoteChatDatasource _remoteChatDatasource =
      RemoteChatDatasource._privateController();
  factory RemoteChatDatasource() {
    return _remoteChatDatasource;
  }

  Future<List<ChatAcceptModel>> getDonorChatRequests(String userEmail) async {
    try {
      List<ChatAcceptModel> chatList = [];
      QuerySnapshot chatQuerySnapshot = await FirebaseFirestore.instance
          .collection('chat_accept')
          .where('donor_email', isEqualTo: userEmail)
          .get();

      if (chatQuerySnapshot.docs.isNotEmpty) {
        for (var doc in chatQuerySnapshot.docs) {
          chatList.add(
              ChatAcceptModel.fromJson((doc.data() as Map<String, dynamic>)));
        }
      } else {
        logError('data not found!');
      }
      return chatList;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ChatAcceptModel>> getTakerChatRequests(String userEmail) async {
    try {
      List<ChatAcceptModel> chatList = [];
      QuerySnapshot chatQuerySnapshot = await FirebaseFirestore.instance
          .collection('chat_accept')
          .where('taker_email', isEqualTo: userEmail)
          .get();

      if (chatQuerySnapshot.docs.isNotEmpty) {
        for (var doc in chatQuerySnapshot.docs) {
          chatList.add(
              ChatAcceptModel.fromJson((doc.data() as Map<String, dynamic>)));
        }
      } else {
        logError('data not found!');
      }
      return chatList;
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot> getMessagesList(String senderId, String receiverId) {
    try {
      List<Stream<QuerySnapshot>> streams = [];

      if (UserController.to.userModel!.type == 'donor') {
        Query<Map<String, dynamic>> query = FirebaseFirestore.instance
            .collection('messages')
            .where('sender_id', isEqualTo: senderId)
            .where('receiver_id', isEqualTo: receiverId);
        // .orderBy('index', descending: false);

        streams.add(query.snapshots());
      } else {
        var query = FirebaseFirestore.instance
            .collection('messages')
            .where('sender_id', isEqualTo: senderId)
            .where('receiver_id', isEqualTo: receiverId);
        // .orderBy('index', descending: false);
        streams.add(query.snapshots());
      }

      // Merge streams into a single stream
      return StreamGroup.merge<QuerySnapshot>(streams);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getLatestMessageID() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('messages')
          .orderBy('index', descending: true)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Access user data
        return userDoc['index'];
      } else {
        // No user found with the specified email
        logError('User not found with email: ');
        return 0;
      }
    } catch (e) {
      rethrow;
    }
  }

  Stream<bool> getOnlineOffline(String senderEmail, String receiverEmail) {
    try {
      if (UserController.to.userModel!.type == 'donor') {
        return FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: receiverEmail)
            .snapshots()
            .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            return snapshot.docs.first.data()['status'] ?? false;
          }
          return false;
        });
      } else if (UserController.to.userModel!.type == 'taker') {
        return FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: senderEmail)
            .snapshots()
            .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            return snapshot.docs.first.data()['status'] ?? false;
          }
          return false;
        });
      } else {
        return Stream.value(false);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendMessage(dynamic payload) async {
    try {
      CollectionReference chats =
          FirebaseFirestore.instance.collection('messages');

      await chats.add(payload);
    } catch (e) {
      rethrow;
    }
  }
}
