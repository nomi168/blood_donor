import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/chat/data/models/chat_accept_model.dart';
import 'package:blood_donor/features/dashboard/chat/domain/chat_repository.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final ChatRepository _repository = ChatRepository();
  List<ChatAcceptModel> chatList = [];
  bool isLoading = false;

  @override
  void onInit() {
    onInitData();
    super.onInit();
  }

  void onInitData() {
    if (UserController.to.userModel!.type == 'donor') {
      getDonorChatList();
    } else {
      getTakerChatList();
    }
  }

  Future<void> getDonorChatList() async {
    isLoading = true;
    chatList.clear();
    chatList = await getDonorChatRequests(UserController.to.userModel!.email);
    isLoading = false;
    update();
  }

  Future<void> getTakerChatList() async {
    isLoading = true;
    chatList.clear();
    chatList = await getTakerChatRequests(UserController.to.userModel!.email);
    isLoading = false;
    update();
  }

  Future<List<ChatAcceptModel>> getDonorChatRequests(String email) async {
    try {
      return await _repository.getDonorChatRequests(email);
    } catch (e) {
      Helper.handleError(e, 'Error while getting donor chat list!');
      return [];
    }
  }

  Future<List<ChatAcceptModel>> getTakerChatRequests(String email) async {
    try {
      return await _repository.getTakerChatRequests(email);
    } catch (e) {
      Helper.handleError(e, 'Error while getting taker chat list!');
      return [];
    }
  }
}
