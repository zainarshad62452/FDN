import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdn/Controllers/donorController.dart';
import 'package:fdn/Controllers/needyController.dart';
import 'package:fdn/Controllers/volunteerController.dart';
import 'package:fdn/Services/NotificationServices.dart';
import 'package:fdn/Services/needyServices.dart';
import 'package:fdn/Services/volunteerSrervices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fdn/Models/foodModel.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Controllers/chatController.dart';
import '../Controllers/loading.dart';
import '../Models/ChatModel.dart';
import '../Models/NewChatModel.dart';
import '../pages/Donor/ChatScreen.dart';
import '../pages/widgets/snackbar.dart';
import 'Authentication.dart';
import 'newChatServices.dart';

class ChatServices {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  sendMessage({ required String reciver, required String content,required String groupChatId}) async {
    try {
      var x = firestore.collection("chats").doc('$groupChatId').collection('messages')
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      ChatModel chat = ChatModel(idFrom: FirebaseAuth.instance.currentUser?.email,idTo: reciver,timestamp: DateTime.now().millisecondsSinceEpoch.toString(),content: content);
      x.set(chat.toJson()).then((value) => print('done'));
    } catch (e) {
      loading(false);
      alertSnackbar("Can't add Item");
    }
  }
  Stream<List<ChatModel>>? streamAllMessages(String groupChatId) {
    try {
      print(groupChatId);
          return firestore.collection("chats").doc('$groupChatId').collection('messages').snapshots().map((event) {
            loading(false);
            List<ChatModel> list = [];
            event.docs.forEach((element) {
              final admin = ChatModel.fromJson(element.data());
              print(admin.content);
              list.add(admin);
            });
            loading(false);
            return list;
          });

  }catch(e){
    print(e);
    return  null;
    }
  }

  startAChat(String reciver,String collection) async {
    String email;
    if(reciver.contains('@')){
      email = reciver;
    }else{
      email = await Authentication().getEmail("${reciver}",collection);
    }
    String id = Authentication().getId('${FirebaseAuth.instance.currentUser?.email}', email);
    if(id == "none" || id == "null"){
      NewChatServices().startChat('${FirebaseAuth.instance.currentUser?.email}', email);
    }else{
      Get.put(ChatController(reciver: '${id}'));
      Get.to(()=>ChatScreen(reciver:email, groupChatId: id));
    }



  }
}

