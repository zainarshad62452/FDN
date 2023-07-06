import 'package:get/get.dart';

import '../Models/RequestFoodModel.dart';
import '../Models/foodModel.dart';
import '../Services/RequestedFoodServices.dart';
import '../Services/foodServices.dart';



final requestedFoodCntr = Get.find<RequestedFoodController>();

class RequestedFoodController extends GetxController {
  RxList<RequestFoodModel>? allItems = <RequestFoodModel>[].obs;
  @override
  void onReady() {
    initAdminStream();
  }

  initAdminStream() async {
    allItems!.bindStream(RequestedFoodServices().streamAllItems()!);
  }
}
