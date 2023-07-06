import 'package:get/get.dart';

import '../Models/donerModel.dart';
import '../Services/donorServices.dart';



final donorCntr = Get.find<DonorController>();

class DonorController extends GetxController {
  Rx<DonorModel>? user = DonorModel().obs;
  RxList<DonorModel>? allUsers = <DonorModel>[].obs;
  @override
  void onReady() {
    initAdminStream();
  }

  initAdminStream() async {
    user!.bindStream(DonorServices().streamUser()!);
    allUsers!.bindStream(DonorServices().streamAllAdmins()!);
  }
}
