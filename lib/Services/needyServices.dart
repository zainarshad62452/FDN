import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fdn/Models/needyModel.dart';

import '../Controllers/loading.dart';
import '../Models/ChatModel.dart';
import '../Models/NewChatModel.dart';
import '../pages/widgets/snackbar.dart';
import 'Reception.dart';


class NeedyServices {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  registerUser({required String name, required User user,String? address,String? contactNo}) async {
    var x = NeedyModel(
        name: name,
        email: user.email,
        registeredOn: Timestamp.now(),
        contactNo: contactNo,
        type: "user",
        uid: user.uid,
        address: address
    );
    try {
      await firestore.collection("needy").doc(user.uid).set(x.toJson());
      loading(false);
      Reception().userReception();
    } catch (e) {
      loading(false);
      alertSnackbar("Can't register user");
    }
  }

  Stream<NeedyModel>? streamUser()  {
    try{
      return firestore
          .collection("needy")
          .doc(auth.currentUser!.uid)
          .snapshots()
          .map((event) {
        if(event.data()!=null){
          return NeedyModel.fromJson(event.data()!);
        }else{
          return NeedyModel();
        }
      });
    }catch(e){
      return null;
    }

  }
  Stream<NeedyModel>? streamSpecificUser(String id)  {
    try{
      return firestore
          .collection("needy")
          .doc(id)
          .snapshots()
          .map((event) {
        if(event.data()!=null){
          print(NeedyModel.fromJson(event.data()!).name);
          return NeedyModel.fromJson(event.data()!);
        }else{
          return NeedyModel();
        }
      });
    }catch(e){
      return null;
    }

  }
  Stream<List<NeedyModel>>? streamAllAdmins() {
    try {
      return firestore.collection("needy").snapshots().map((event) {
        loading(false);
        List<NeedyModel> list = [];
        event.docs.forEach((element) {
          final admin = NeedyModel.fromJson(element.data());
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
  updateLocation(double latitude,double longitude) async {
    try {
      loading(true);
      await firestore
          .collection("needy")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({"latitude": latitude,"longitude": longitude})
          .then((value) =>snackbar("Done","Your Location has been Set")).onError((error, stackTrace)=>alertSnackbar("Error $error"));
      loading(false);
    } catch (e) {
      loading(false);
    }
  }
}
