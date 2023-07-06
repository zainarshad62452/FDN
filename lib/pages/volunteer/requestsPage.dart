import 'package:fdn/Controllers/donorController.dart';
import 'package:fdn/Controllers/foodController.dart';
import 'package:fdn/Controllers/loading.dart';
import 'package:fdn/Controllers/volunteerController.dart';
import 'package:fdn/main.dart';
import 'package:fdn/pages/Donor/requestedFoodDetails.dart';
import 'package:fdn/pages/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';

import '../../Controllers/requestedFoodController.dart';
import '../volunteer/requestedPageDetails.dart';

class VolunteerRequestsPage extends StatelessWidget {
  VolunteerRequestsPage({
    Key? key,
  }) : super(key: key);

  RxInt valueForVisible = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
      children: [
        ListView(
          children: [
            Column(
                children: List.generate(int.parse('${requestedFoodCntr.allItems!.length}'), (index) {
                  try{
                    if(requestedFoodCntr.allItems!.value[index].requestedVolunteer == volunteerCntr.user!.value.email
                        && requestedFoodCntr.allItems!.value[index].reservedStatus == "${foodStatus.requestToVolunteer}"
                        // && requestedFoodCntr.allItems!.value[index].resurved==false
                    ){
                      valueForVisible.value++;
                      return Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black,width: 0.5),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListTile(
                              title: Text('${foodCntr.allItems!.value[requestedFoodCntr.allItems!.value[index].index!.toInt()].name}'),
                              leading: Text('${requestedFoodCntr.allItems!.value[index].quantity}'),
                              trailing: Text('${requestedFoodCntr.allItems!.value[index].requestedBy}'),
                              onTap: (){
                                Get.to(()=>RequestedFoodScreen(food: requestedFoodCntr.allItems!.value[index],isDonor: false,));
                              },
                            ),
                          ),
                        ),
                      );
                    }else{
                      return SizedBox();
                    }
                  }catch(e){
                    return Text('$e');
                  }
                })
            ),
            Column(
                children: List.generate(int.parse('${foodCntr.allItems!.length}'), (index) {
                  try{
                    if(foodCntr.allItems!.value[index].requestedVolunteer == FirebaseAuth.instance.currentUser?.email && foodCntr.allItems!.value[index].reservedStatus == "${foodStatus.requestToVolunteer}"){
                      valueForVisible.value++;
                      return Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black,width: 0.5),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListTile(
                              title: Text('${foodCntr.allItems!.value[index].name}'),
                              leading: Text('${foodCntr.allItems!.value[index].quantity}'),
                              trailing: Text('${foodCntr.allItems!.value[index].resurvedBy}'),
                              onTap: (){
                                Get.to(()=>RequestedFoodScreen2(food: foodCntr.allItems!.value[index],isDonor: false,));
                              },
                            ),
                          ),
                        ),
                      );
                    }else{
                      return SizedBox();
                    }
                  }catch(e){
                    return Text('$e');
                  }
                })
            ),
          ],
        ),

        Visibility(
            visible: valueForVisible.value==0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('images/emptyghost.json'),
                Text('No Request Found',style: TextStyle(fontSize: 20.0),),
              ],
            )),
      ],
    ),);
  }
}