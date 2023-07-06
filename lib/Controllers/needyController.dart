import 'package:fdn/Models/needyModel.dart';
import 'package:fdn/Services/needyServices.dart';
import 'package:get/get.dart';

import '../Models/donerModel.dart';



final needyCntr = Get.find<NeedyController>();

class NeedyController extends GetxController {
  Rx<NeedyModel>? user = NeedyModel().obs;
  RxList<NeedyModel>? allUsers = <NeedyModel>[].obs;
  @override
  void onReady() {
    initAdminStream();
  }

  initAdminStream() async {
    user!.bindStream(NeedyServices().streamUser()!);
    allUsers!.bindStream(NeedyServices().streamAllAdmins()!);
  }
}
