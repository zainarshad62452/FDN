import 'package:get/get.dart';

import '../Models/foodModel.dart';
import '../Services/foodServices.dart';



final foodCntr = Get.find<FoodController>();

class FoodController extends GetxController {
  RxList<FoodModel>? allItems = <FoodModel>[].obs;
  @override
  void onReady() {
    initAdminStream();
  }

  initAdminStream() async {
    allItems!.bindStream(FoodServices().streamAllItems()!);
  }
}
