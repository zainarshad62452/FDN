import 'package:get/get.dart';

import '../Models/ChatModel.dart';
import '../Services/ChatServices.dart';



final chatCntr = Get.find<ChatController>();

class ChatController extends GetxController {
  RxList<ChatModel>? allMessages = <ChatModel>[].obs;
  String reciver;
  ChatController({required this.reciver});
  @override
  void onReady() {
    initChatStream();
  }

  initChatStream() async {
    allMessages!.bindStream(ChatServices().streamAllMessages(reciver)!);
  }
}
