import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdn/Controllers/donorController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fdn/Models/donerModel.dart';

import '../Controllers/loading.dart';
import '../Models/ChatModel.dart';
import '../pages/widgets/snackbar.dart';
import 'Reception.dart';


class DonorServices {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  registerUser({required String name, required User user,String? address,String? contactNo}) async {
    var x = DonorModel(
      name: name,
      email: user.email,
      registeredOn: Timestamp.now(),
      contactNo: contactNo,
      type: "donor",
      uid: user.uid,
      address: address
    );
    try {
      await firestore.collection("donor").doc(user.uid).set(x.toJson());
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
      ChatModel chat = ChatModel(idFrom: donorCntr.user!.value.uid,idTo: reciver,timestamp: DateTime.now().millisecondsSinceEpoch.toString(),content: groupChatId);
      x.set(chat.toJson()).then((value) => print('done'));
    } catch (e) {
      alertSnackbar("Can't add Item");
    }
  }

  Stream<DonorModel>? streamUser()  {
    try{
      return firestore
          .collection("donor")
          .doc(auth.currentUser!.uid)
          .snapshots()
          .map((event) {
        if(event.data()!=null){
          return DonorModel.fromJson(event.data()!);
        }else{
          return DonorModel();
        }
      });
    }catch(e){
      return null;
    }

  }
  Stream<List<DonorModel>>? streamAllAdmins() {
    try {
      return firestore.collection("donor").snapshots().map((event) {
        loading(false);
        List<DonorModel> list = [];
        event.docs.forEach((element) {
          final admin = DonorModel.fromJson(element.data());
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
