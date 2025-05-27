import 'package:blood_donor/features/dashboard/chat/data/datasource/remote_chat_datasource.dart';
import 'package:blood_donor/features/dashboard/chat/data/models/chat_accept_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  ChatRepository._privateController();
  static final ChatRepository _chatRepository =
      ChatRepository._privateController();
  factory ChatRepository() {
    return _chatRepository;
  }
  final RemoteChatDatasource _chatDatasource = RemoteChatDatasource();
  Future<List<ChatAcceptModel>> getDonorChatRequests(String email) async {
    try {
      return await _chatDatasource.getDonorChatRequests(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ChatAcceptModel>> getTakerChatRequests(String email) async {
    try {
      return await _chatDatasource.getTakerChatRequests(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getLatestMessageID() async {
    try {
      return await _chatDatasource.getLatestMessageID();
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot> getMessagesList(String senderId, String receiverId) {
    try {
      return _chatDatasource.getMessagesList(senderId, receiverId);
    } catch (e) {
      rethrow;
    }
  }

  Stream<bool> getOnlineOffline(String senderEmail, String receiverEmail) {
    try {
      return _chatDatasource.getOnlineOffline(senderEmail, receiverEmail);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendMessage(dynamic payload) async {
    try {
      return await _chatDatasource.sendMessage(payload);
    } catch (e) {
      rethrow;
    }
  }
}
