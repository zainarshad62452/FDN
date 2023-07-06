import 'package:get/get.dart';

import '../Models/ChatModel.dart';
import '../Models/NewChatModel.dart';
import '../Services/ChatServices.dart';
import '../Services/newChatServices.dart';



final newChatCntr = Get.find<NewChatController>();

class NewChatController extends GetxController {
  RxList<NewChatModel>? allUsers = <NewChatModel>[].obs;
  @override
  void onReady() {
    initChatStream();
  }

  initChatStream() async {
    allUsers!.bindStream(NewChatServices().streamAllChats()!);
  }
}
