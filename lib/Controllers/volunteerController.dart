import 'package:fdn/Models/needyModel.dart';
import 'package:fdn/Services/needyServices.dart';
import 'package:get/get.dart';

import '../Models/donerModel.dart';
import '../Models/volunteerModel.dart';
import '../Services/volunteerSrervices.dart';



final volunteerCntr = Get.find<VolunteerController>();

class VolunteerController extends GetxController {
  Rx<VolunteerModel>? user = VolunteerModel().obs;
  RxList<VolunteerModel>? allUsers = <VolunteerModel>[].obs;
  @override
  void onReady() {
    initAdminStream();
  }

  initAdminStream() async {
    user!.bindStream(VolunteerServices().streamUser()!);
    allUsers!.bindStream(VolunteerServices().streamAllAdmins()!);
  }
}
