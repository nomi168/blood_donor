import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/dashboard/feeds/data/models/chat_request_model.dart';
import 'package:blood_donor/features/dashboard/feeds/domain/feed_repository.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ChatRequestController extends GetxController {
  final FeedRepository _feedRepository = FeedRepository();
  List<ChatRequestModel> chatRequestList = [];
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    getChatRequestList();
  }

  Future<void> getChatRequestList() async {
    chatRequestList.clear();
    isLoading = true;
    update();
    chatRequestList = await getChatRequestData();
    isLoading = false;

    update();
  }

  Future<List<ChatRequestModel>> getChatRequestData() async {
    try {
      return await _feedRepository.getChatRequestData();
    } catch (e) {
      Helper.handleError(e, 'Error while getting chat request data!');
      return [];
    }
  }

  Future<void> deleteChatRequest(String email) async {
    try {
      showLoader('delete request...');
      return await _feedRepository.deleteChatRequest(email);
    } catch (e) {
      Helper.handleError(e, 'Error while deleting chat request!');
      rethrow;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<bool> acceptChatRequest(Map<String,dynamic> payload) async {
    try {
      showLoader('accepting request...');
      return await _feedRepository.acceptChatRequest(payload);
    } catch (e) {
      Helper.handleError(e, 'Error while accepting chat request!');
      rethrow;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> updateChatRequest(String email) async {
    try {
      return await _feedRepository.updateChatRequest(email);
    } catch (e) {
      Helper.handleError(e, 'Error while updating status!');
      rethrow;
    }
  }
}
