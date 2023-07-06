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
import '../Controllers/newChatController.dart';
import '../Models/ChatModel.dart';
import '../Models/NewChatModel.dart';
import '../pages/Donor/ChatScreen.dart';
import '../pages/widgets/snackbar.dart';

class NewChatServices {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  String startChat(String reciver,String sender){
    try{
      var x = firestore.collection("chats").doc();
      NewChatModel chatModel = NewChatModel(groupID: x.id,user1:  sender,user2: reciver);
      x.set(chatModel.toJson()).then((value){
        Get.put(ChatController(reciver: '${x.id}'));
        print('${chatModel.user1==FirebaseAuth.instance.currentUser!.email?'${reciver}':'${sender}'}');
        Get.to(()=>ChatScreen(reciver:'${chatModel.user1==FirebaseAuth.instance.currentUser?.email?'${chatModel.user2}':'${chatModel.user1}'}', groupChatId: '${x.id}',));

      }) ;

      return x.id;
    }catch(e){
      print(e);
      return e.toString();
    }
  }
  Stream<List<NewChatModel>>? streamAllChats() {
    try {
        return firestore.collection("chats").snapshots().map((event) {
          loading(false);
          List<NewChatModel> list = [];
          event.docs.forEach((element) {
            final admin = NewChatModel.fromJson(element.data());
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

  delete(NewChatModel item,) async {
    try {
      // loading(true);
      await firestore
          .collection("chats")
          .doc(item.groupID)
          .delete().then((value) => {print("Successfully Deleted,\nRefresh To see Changes")});
      loading(false);
    } catch (e) {
      loading(false);
    }
  }
}

