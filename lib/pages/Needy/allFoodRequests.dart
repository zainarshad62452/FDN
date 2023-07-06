import 'package:fdn/Controllers/donorController.dart';
import 'package:fdn/Controllers/foodController.dart';
import 'package:fdn/Controllers/loading.dart';
import 'package:fdn/pages/Donor/requestedFoodDetails.dart';
import 'package:fdn/pages/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';

import '../../Controllers/needyController.dart';
import '../../Controllers/requestedFoodController.dart';

class AllFoodRequestsScreen extends StatelessWidget {
   AllFoodRequestsScreen({Key? key}) : super(key: key);

  var value = 0.obs;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        !loading()
            ?Scaffold(
          appBar: AppBar(
            title: Text(
              "Food Requests",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            elevation: 0.5,
            iconTheme: IconThemeData(color: Colors.white),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Theme.of(context).primaryColor,
                        Theme.of(context).hintColor,
                      ])),
            ),
          ),
          body:
          ListView.builder(
              itemCount: requestedFoodCntr.allItems!.length,
              itemBuilder: (ct,index){
                try{
                  if(requestedFoodCntr.allItems!.value[index].requestedBy == needyCntr.user!.value.email){
                    value.value++;
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
                            subtitle: Text('${requestedFoodCntr.allItems!.value[index].resurved==true?'Reserved':'Pending'}'),
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
              }),
        ):
        LoadingWidget(),
     Visibility(
     visible: value.value==0,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Lottie.asset('images/emptyghost.json'),
    Text('No Request Found',style: TextStyle(fontSize: 20.0),),
    ],
    )),
        LoadingWidget(),
      ],
    );
  }
}
