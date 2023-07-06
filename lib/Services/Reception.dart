import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdn/Controllers/needyController.dart';
import 'package:fdn/pages/Needy/needyDashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fdn/pages/common/login_page.dart';
import 'package:get/get.dart';
import '../Controllers/donorController.dart';
import '../Controllers/foodController.dart';
import '../Controllers/loading.dart';
import '../Controllers/newChatController.dart';
import '../Controllers/requestedFoodController.dart';
import '../Controllers/volunteerController.dart';
import '../Models/UserType.dart';
import '../pages/Auth/emailVerification.dart';
import '../pages/Donor/dashboard.dart';
import '../pages/volunteer/volunteerDashbord.dart';
import 'Authentication.dart';

class Reception {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  Future<UserType> fetchUserType() async {
    String type = "none";
    try {
      type = await firestore
          .collection("donor")
          .doc(auth.currentUser!.uid)
          .get()
            .then((value) => value['userType'].toString());
    } catch (e) {
      try {
        type = await firestore
            .collection("needy")
            .doc(auth.currentUser!.uid)
            .get()
            .then((value) => value['userType'].toString());
      } catch (e) {
        try{
          type = await firestore
              .collection("volunteer")
              .doc(auth.currentUser!.uid)
              .get()
              .then((value) => value['userType'].toString());
        }catch(e){
          return UserType().instance(type);
        }
        return UserType().instance(type);
      }
      return UserType().instance(type);
    }
    return UserType().instance(type);
  }

  userReception() async {
    final type = await fetchUserType();
    if(FirebaseAuth.instance.currentUser!=null){
      if(!FirebaseAuth.instance.currentUser!.emailVerified){
        FirebaseAuth.instance.currentUser!.sendEmailVerification();
        Get.to(()=>EmailVerification());
      }else if (type.user) {
        Get.offAll(() => NeedyDashboard());
        Get.put(NeedyController());
        Get.put(VolunteerController());
        Get.put(DonorController());
      } else if (type.donor) {
        Get.offAll(() => Dashboard());
        Get.put(DonorController());
        Get.put(NeedyController());
        Get.put(VolunteerController());
      }else if (type.volunteer) {
        Get.offAll(() => VolunteerDashboard());
        Get.put(VolunteerController());
        Get.put(NeedyController());
        Get.put(DonorController());
      }else{
        Authentication().signOut();
      }
    }else{
      Get.offAll(() => LoginPage());
    }
  }
}
