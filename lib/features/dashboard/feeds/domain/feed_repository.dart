import 'package:blood_donor/features/dashboard/feeds/data/datasource/remote_feed_datasource.dart';
import 'package:blood_donor/features/dashboard/feeds/data/models/chat_request_model.dart';
import 'package:blood_donor/features/dashboard/feeds/data/models/feed_taker_model.dart';

class FeedRepository {
  final RemoteFeedDatasource _feedDatasource = RemoteFeedDatasource();
  FeedRepository._privateController();
  static final FeedRepository _feedRepository =
      FeedRepository._privateController();
  factory FeedRepository() {
    return _feedRepository;
  }

  Future<List<FeedTakerModel>> getFeedTakerData() async {
    try {
      return await _feedDatasource.getFeedTakerData();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> sendChatRequest(Map<String, dynamic> payload) async {
    try {
      return await _feedDatasource.sendChatRequest(payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendNotification(String email) async {
    try {
      return await _feedDatasource.sendNotification(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool?> getavailableDonor(String email) async {
    try {
      return await _feedDatasource.getavailableDonor(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ChatRequestModel>> getChatRequestData() async {
    try {
      return await _feedDatasource.getChatRequestData();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteChatRequest(String email) async {
    try {
      return await _feedDatasource.deleteChatRequest(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> acceptChatRequest(Map<String, dynamic> payload) async {
    try {
      return await _feedDatasource.acceptChatRequest(payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateChatRequest(String email) async {
    try {
      return await _feedDatasource.updateChatRequest(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteExpiredRequests() async {
    try {
      return await _feedDatasource.deleteExpiredRequests();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateAppStatus(bool status) async {
    try {
      return await _feedDatasource.updateAppStatus(status);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> aceeptDonationRequest(Map<String, dynamic> payload) async {
    try {
      return await _feedDatasource.aceeptDonationRequest(payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkUserCnicVerification(String card) async {
    try {
      return await _feedDatasource.checkUserCnicVerification(card);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkChatBox(Map<String, dynamic> payload) async {
    try {
      return await _feedDatasource.checkChatBox(payload);
    } catch (error) {
      rethrow;
    }
  }

  Future<String?> getDonorCurrentLocation(String donorEmail) async {
    try {
      return await _feedDatasource.getDonorCurrentLocation(donorEmail);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<FeedTakerModel>> getTakerList() async {
    try {
      return await _feedDatasource.getTakerList();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteBloodRequest(bool isActive) async {
    try {
      return await _feedDatasource.deleteBloodRequest(isActive);
    } catch (e) {
      rethrow;
    }
  }
}
