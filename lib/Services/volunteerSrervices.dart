import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fdn/Models/needyModel.dart';

import '../Controllers/loading.dart';
import '../Models/ChatModel.dart';
import '../Models/volunteerModel.dart';
import '../pages/widgets/snackbar.dart';
import 'Reception.dart';


class VolunteerServices {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  registerUser({required String name, required User user,String? address,String? contactNo}) async {
    var x = VolunteerModel(
        name: name,
        email: user.email,
        registeredOn: Timestamp.now(),
        contactNo: contactNo,
        type: "volunteer",
        uid: user.uid,
        address: address
    );
    try {
      await firestore.collection("volunteer").doc(user.uid).set(x.toJson());
      loading(false);
      Reception().userReception();
    } catch (e) {
      loading(false);
      alertSnackbar("Can't register user");
    }
  }
  startChatSendMessage({ required String reciver, required String type,required String groupChatId}) async {
    try {
      var x = firestore.collection("donor").doc(FirebaseAuth.instance.currentUser?.uid)
          .collection(reciver)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      ChatModel chat = ChatModel(idFrom: FirebaseAuth.instance.currentUser?.uid,idTo: reciver,timestamp: DateTime.now().millisecondsSinceEpoch.toString(),content: type);
      x.set(chat.toJson()).then((value) => print('done'));
    } catch (e) {
      loading(false);
      alertSnackbar("Can't add Item");
    }
  }
  Stream<VolunteerModel>? streamUser()  {
    try{
      return firestore
          .collection("volunteer")
          .doc(auth.currentUser!.uid)
          .snapshots()
          .map((event) {
            if(event.data()!=null){
             return VolunteerModel.fromJson(event.data()!);
            }else{
              return VolunteerModel();
            }
       });
    }catch(e){
      return null;
    }

  }
  Stream<List<VolunteerModel>>? streamAllAdmins() {
    try {
      return firestore.collection("volunteer").snapshots().map((event) {
        loading(false);
        List<VolunteerModel> list = [];
        event.docs.forEach((element) {
          final admin = VolunteerModel.fromJson(element.data());
          list.add(admin);
        });
        loading(false);
        return list;
      });
    } catch (e) {
      loading(false);
      return null;
    }
  }
}
