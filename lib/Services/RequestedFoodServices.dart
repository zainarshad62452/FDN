import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdn/Controllers/donorController.dart';
import 'package:fdn/Controllers/needyController.dart';
import 'package:fdn/Services/NotificationServices.dart';
import 'package:fdn/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fdn/Models/foodModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Controllers/loading.dart';
import '../Models/RequestFoodModel.dart';
import '../pages/widgets/snackbar.dart';

class RequestedFoodServices {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  registerItem({
    String? food,
    String? by,
    String? quantity,
    String? requestedTo,
    int? index,
    double? lat,
    double? lng
}) async {
    loading(true);
    var x = RequestFoodModel(
      requestedFood: food,
      requestedBy: needyCntr.user!.value.email,
      requestedUid: needyCntr.user!.value.uid,
      resurved: false,
      requestedOn: Timestamp.now(),
      quantity: quantity,
      requestedTo: requestedTo,
      index: index,
      reservedStatus: '${foodStatus.pending}',
      reservedLatitude: lat,
      reservedLongitude: lng
    );
    try {
      final user = firestore.collection("food-requests").doc();
      // DocumentSnapshot snap = await firestore.collection('donor').doc(requestedTo).get();
      // String token = snap['token'];
      x.uid = user.id;
      user.set(x.toJson()).then((value) {
        // NotificationServices().sendPushMessage(token, 'You have a food request from ${needyCntr.user!.value.email}', 'Food Request');
        snackbar('Done','Request has been successfully sent to Donor');
      }).onError((error, stackTrace) => alertSnackbar('Error $error'));
      loading(false);
      Get.back();
    } catch (e) {
      loading(false);
      alertSnackbar("$e Can't add Item");
    }
  }
  Stream<List<RequestFoodModel>>? streamAllItems() {
    try {
      return firestore.collection("food-requests").snapshots().map((event) {
        loading(false);
        List<RequestFoodModel> list = [];
        event.docs.forEach((element) {
          final admin = RequestFoodModel.fromJson(element.data());
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
  accept(String item,String foodModel,String? quantity,String? uid) async {
    try {
      loading(true);
      print(Value);
      await firestore
          .collection("food-requests")
          .doc(item)
          .update({"resurved": true,}).then((value) async {
        firestore
            .collection("food-requests")
            .doc(item)
            .update({"reservedStatus": "${foodStatus.readyToCollect}"});
            print(uid);
        DocumentSnapshot snap = await firestore.collection('needy').doc(uid).get();
        String token = snap['token'];
        await firestore
            .collection("posts")
            .doc(foodModel)
            .update({"quantity": "$quantity",})
            .then((value) {
          NotificationServices().sendPushMessage(token, 'The Donor ${donorCntr.user!.value.email} have accepted your Food Request, You can get you food on Food Location', 'Request Accepted');
          snackbar("Done", "Successfully Accepted the request");
        }).onError((error, stackTrace)=>alertSnackbar("Error this is error $error"));
      }).onError((error, stackTrace) => alertSnackbar("Error this is error 1 $error"));
      loading(false);
    } catch (e) {
      loading(false);
    }
  }
  acceptedByVolunteer(String item,String? uid,bool isFood)async {
      try {
        loading(true);
        print(Value);
        await firestore
            .collection("food-requests")
            .doc(item)
            .update({"isAccepted": true,}).then((value) async {
          print(uid);
          DocumentSnapshot snap = await firestore.collection('needy').doc(uid).get();
          String token = snap['token'];
          await firestore
              .collection("food-requests")
              .doc(item)
              .update({"reservedStatus": "${foodStatus.willDeliverByVolunteer}",})
              .then((value) {
            NotificationServices().sendPushMessage(token, 'The Volunteer have accepted your Food Request, You can give your Food Location', 'Request Accepted');
            snackbar("Done", "Successfully Accepted the request");
          }).onError((error, stackTrace)=>alertSnackbar("Error this is error $error"));
        }).onError((error, stackTrace) => alertSnackbar("Error this is error 1 $error"));
        loading(false);
      } catch (e) {
        loading(false);
      }

  }
  update(RequestFoodModel item,String index,String Value,String title) async {
    try {
      loading(true);
      print(Value);
      await firestore
          .collection("food-requests")
          .doc(item.uid)
          .update({"$index": "$Value"})
          .then((value) =>alertSnackbar("$title")).onError((error, stackTrace)=>alertSnackbar("Error $error"));
      loading(false);
    } catch (e) {
      loading(false);
    }
  }

  delete(String item,) async {
    try {
      // loading(true);
      await firestore
          .collection("food-requests")
          .doc(item)
          .delete().then((value) => {snackbar("Done!","Successfully Deleted,\nRefresh To see Changes")}).onError((error, stackTrace) => alertSnackbar("Error $error"));
      loading(false);
    } catch (e) {
      loading(false);
    }
  }
}

