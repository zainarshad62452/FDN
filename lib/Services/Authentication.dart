import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdn/Services/needyServices.dart';
import 'package:fdn/Services/volunteerSrervices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../Controllers/loading.dart';
import '../Controllers/newChatController.dart';
import '../pages/Auth/emailVerification.dart';
import '../pages/Auth/forgot_password_verification_page.dart';
import '../pages/common/login_page.dart';
import '../pages/widgets/snackbar.dart';
import 'Reception.dart';
import 'donorServices.dart';


class Authentication {
  FirebaseAuth auth = FirebaseAuth.instance;
  createAccount(
      {required String name,
        required String email,
        required String pass,String? address,String? contactNo,required bool isDonor,required bool isVolunteer}) async {
    loading(true);
    try {
      final user = await auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      if (user.user != null) {
        isDonor
            ?
        DonorServices().registerUser(
            name: name,
            user: user.user!,address: address,contactNo: contactNo)
            :!isDonor && isVolunteer
            ?VolunteerServices().registerUser(name: name, user: user.user!,address: address,contactNo: contactNo)
            : NeedyServices().registerUser(
            name: name,
            user: user.user!,address: address,contactNo: contactNo);

        Get.offAll(()=>EmailVerification());
        loading(false);

      } else {
        loading(false);
        alertSnackbar(
          "Unknown Error",
        );
      }
    } catch (e) {
      loading(false);
      alertSnackbar(e.toString().contains(']')
          ? e.toString().split(']').last
          : e.toString()); //TODO firebase errors list
    }
  }
  Future<String> getEmail(String id,String collection) async {
      return await FirebaseFirestore.instance
          .collection(collection)
          .doc(id)
          .get()
          .then((value) => value['email'].toString());
  }

  // signinWithEmail(String email, String pass) async {
  //   try {
  //     loading(true);
  //     await auth
  //         .signInWithEmailAndPassword(email: email, password: pass)
  //         .then((value) {
  //       if (value.user != null) {
  //         loading(false);
  //         Reception().userReception();
  //       } else {
  //         loading(false);
  //         alertSnackbar("Unknown error");
  //       }
  //     });
  //   } catch (e) {
  //     loading(false);
  //     alertSnackbar(e.toString().split(']').last); //TODO firebase exception
  //   }
  // }
  signinWithEmail(String email, String pass) async {
    try {
      loading(true);
      await auth
          .signInWithEmailAndPassword(email: email, password: pass)
          .then((value) {
        if (value.user != null) {
          loading(false);
          if (auth.currentUser!.emailVerified)
            Reception().userReception();
          else
            Get.offAll(() => EmailVerification());
        } else {
          loading(false);
          alertSnackbar("Unknown error");
        }
      });
    } catch (e) {
      loading(false);
      alertSnackbar(e.toString().split(']').last); //TODO1 firebase exception
    }
  }

  forgotPassword(String email) async {
    loading(true);
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.sendPasswordResetEmail(email: email);
      Get.to(()=>ForgotPasswordVerificationPage(email:email));
      loading(false);
      snackbar('Success', 'Password reset email sent to ${email}');
    } catch (e) {
      loading(false);
      alertSnackbar(e.toString().split(']').last); //TODO firebase exception
    }
  }

  String getId(String sender,String reciver){
    var chats = newChatCntr.allUsers?.value;
    String id = "none";
    for(var chat in chats!){
      if((chat.user1 == sender && chat.user2 == reciver) || (chat.user2 == sender && chat.user1 == reciver)){
        id = "${chat.groupID}";
      }
    }
    return id;
  }

  signOut() async {
    try {
      await auth.signOut();
      Get.put(LoadingController());
      Get.offAll(() => LoginPage());
    } catch (e) {
      snackbar("Error Signing Out", e.toString()); //TODO firebase exception
    }
  }
}
