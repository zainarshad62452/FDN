import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdn/Controllers/donorController.dart';
import 'package:fdn/Controllers/needyController.dart';
import 'package:fdn/Services/NotificationServices.dart';
import 'package:fdn/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fdn/Models/foodModel.dart';

import '../Controllers/loading.dart';
import '../Models/needyModel.dart';
import '../pages/widgets/snackbar.dart';

class FoodServices {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  registerItem({required String name, String? description,String? quantity, String? category,DateTime? date,required String? itemPic,String? location,double? longitude,double? latitude,String? phone}) async {
    loading(true);
    var x = FoodModel(
        name: name,
        description: description,
        registeredOn: Timestamp.now(),
        category: category,
        quantity: quantity,
        date: date,
        profileImageUrl: itemPic,
      location: location,
      longitude: longitude,
      latitude: latitude,
      phone: phone,
      postBy: FirebaseAuth.instance.currentUser?.uid,
        resurved: false,
    );
    try {
      final user =await firestore.collection("posts").doc();
      x.itemId = user.id;
      print("This is our food::::");
      user.set(x.toJson()).then((value) => print('Successfully Added Item'));
      loading(false);
    } catch (e) {
      loading(false);
      alertSnackbar("Can't add Item");
    }
  }

  // Stream<ItemModel> streamItem()  {
  //   return  firestore
  //       .collection("items")
  //       .doc(auth.currentUser!.uid)
  //       .snapshots()
  //       .map((event) => ItemModel.fromJson(event.data()!));
  // }
  Stream<List<FoodModel>>? streamAllItems() {
    try {
      return firestore.collection("posts").snapshots().map((event) {
        loading(false);
        List<FoodModel> list = [];
        event.docs.forEach((element) {
          final admin = FoodModel.fromJson(element.data());
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
  update(FoodModel item,String index,String Value,String title) async {
    try {
      loading(true);
      print(Value);
      await firestore
          .collection("posts")
          .doc(item.itemId)
          .update({"$index": "$Value"})
      .then((value) =>alertSnackbar("$title")).onError((error, stackTrace)=>alertSnackbar("Error $error"));
      loading(false);
    } catch (e) {
      loading(false);
    }
  }
  resurve(FoodModel item,String? email,NeedyModel? user) async {
    try {
      loading(true);
      await firestore
          .collection("posts")
          .doc(item.itemId)
          .update({"resurved": true,"resurvedByUid":FirebaseAuth.instance.currentUser?.uid,"resurvedBy": "$email","reservedStatus": "${foodStatus.readyToCollect}","reservedLatitude":user?.latitude,"reservedLongitude":user?.longitude})
          .then((value) async {
        DocumentSnapshot snap = await firestore.collection('donor').doc(item.postBy).get();
        String token = snap['token'];
        NotificationServices().sendPushMessage(token, 'The user ${needyCntr.user!.value.email} have reserved the food', 'Food Reserved');
        snackbar("Done", "Successfully Reserved The Food");
      }).onError((error, stackTrace)=>alertSnackbar("Error $error"));
      loading(false);
    } catch (e) {
      loading(false);
    }
  }
  updateInt(FoodModel item,String index,int Value) async {
    try {
      loading(true);
      print(Value);
      await firestore
          .collection("posts")
          .doc(item.itemId)
          .update({"$index": Value})
      .then((value) => {alertSnackbar("Successfully Changed")}).onError((error, stackTrace) => alertSnackbar("Error this is error $error"));
      loading(false);
    } catch (e) {
      loading(false);
    }
  }

  delete(FoodModel item,) async {
    try {
      // loading(true);
      await firestore
          .collection("posts")
          .doc(item.itemId)
          .delete().then((value) => {print("Successfully Deleted,\nRefresh To see Changes")});
      loading(false);
    } catch (e) {
      loading(false);
    }
  }
  updateLocation(String id,double latitude,double longitude) async {
    try {
      loading(true);
      await firestore
          .collection("posts")
          .doc(id)
          .update({"latitude": latitude,"longitude": longitude})
          .then((value) =>snackbar("Done","Food Location has been updated")).onError((error, stackTrace)=>alertSnackbar("Error $error"));
      loading(false);
    } catch (e) {
      loading(false);
    }
  }
}

