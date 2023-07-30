import 'dart:async';

import 'package:fdn/Services/ChatServices.dart';
import 'package:fdn/pages/Needy/foodReservationDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../Controllers/chatController.dart';
import '../../Controllers/foodController.dart';
import '../../Controllers/needyController.dart';
import '../../Controllers/requestedFoodController.dart';
import '../../Services/Authentication.dart';
import '../../Services/RequestedFoodServices.dart';
import '../../Services/foodServices.dart';
import '../../Services/newChatServices.dart';
import '../Donor/ChatScreen.dart';
import '../common/carouselSlider.dart';
import '../common/locationScreen.dart';
import '../common/theme_helper.dart';
import '../widgets/header_widget.dart';
import '../widgets/snackbar.dart';
import '../widgets/warning.dart';
import 'allFoodRequests.dart';
import 'needyDashboard.dart';
import 'package:fdn/Services/storage_service.dart';

class AllFoodPageForNeedy extends StatelessWidget {
  AllFoodPageForNeedy({Key? key}) : super(key: key);

  final Storage storage = Storage();
  final DateFormat formatter = DateFormat('dd,MMMM,yyyy');


  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 100.0),
            width: MediaQuery.of(context).size.width,
            child: Carouselslider(),
          ),
          Container(
            height: 100,
            child: HeaderWidget(100, false, Icons.house_rounded),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 250),
              child: ListView.builder(
                  padding: EdgeInsets.all(5),
                  itemCount: foodCntr.allItems?.value.length,
                  itemBuilder: (context, index) {
                    var remainingTime = foodCntr.allItems![index].date!.difference(DateTime.now());
                    Timer.periodic(Duration(minutes: 10), (timer) {
                      var currentDate = DateTime.now();
                      remainingTime = foodCntr.allItems![index].date!.difference(DateTime.now());
                      print(remainingTime);
                      if (remainingTime.isNegative) {
                        FoodServices().delete(foodCntr.allItems![index]);
                        timer.cancel();
                      }
                    });
                    if (!remainingTime.isNegative && foodCntr.allItems![index].resurved==false) {
                      print(remainingTime);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Expanded(
                          child: Container(
                              height: 230,
                              decoration: BoxDecoration(
                                  color: HexColor('#ffffff'),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: HexColor('#28282B'),width: 2.0)
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    height: 150,
                                    width: 150,
                                    color: Colors.red,
                                    child: FutureBuilder(
                                        future: storage.downloadURL(
                                            foodCntr.allItems!.value[index].profileImageUrl.toString()),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String>
                                            snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                              snapshot.hasData) {
                                            return Container(
                                              width: 200,
                                              height: 150,
                                              child: Image.network(
                                                snapshot.data!,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          }
                                          if (snapshot.connectionState ==
                                              ConnectionState
                                                  .waiting ||
                                              !snapshot.hasData) {
                                            return Lottie.asset('images/loading.json');
                                          }
                                          return Container();
                                        }),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Stack(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 150,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Name:  ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255, 57, 4, 62),
                                                        ),
                                                      ),
                                                      Text('${foodCntr.allItems!.value[index].name}'),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 150,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Quantity:  ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255, 57, 4, 62),
                                                        ),
                                                      ),
                                                      Text('${foodCntr.allItems!.value[index].quantity}'),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 150,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Phone:  ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255, 57, 4, 62),
                                                        ),
                                                      ),
                                                      Text('${foodCntr.allItems!.value[index].phone}'),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 150,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Expiry:  ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255, 57, 4, 62),
                                                        ),
                                                      ),
                                                      Text('${formatter.format(foodCntr.allItems!.value[index].date!)} \n ${DateFormat.jm().format(foodCntr.allItems!.value[index].date!)}'),

                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap:(){
                                                    Get.to(()=> LocationScreen(latitude: foodCntr.allItems!.value[index].latitude!.toDouble(),longitude: foodCntr.allItems!.value[index].longitude!.toDouble(),));
                                                  },
                                                  child: Container(
                                                    padding:
                                                    EdgeInsets.only(top: 5),
                                                    width: 200,
                                                    height: 40,
                                                    child: Center(
                                                      child: Container(
                                                        height: 40,
                                                        width: 170,
                                                        decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .black26,
                                                                offset:
                                                                Offset(0, 10),
                                                                blurRadius: 10.0),
                                                          ],
                                                          color: HexColor('#28282B'),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(20),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'View Location',
                                                            style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                    onTap:(){
                                                      showDialog(context: context, builder: (ctx){
                                                        TextEditingController controller = TextEditingController();
                                                        return AlertDialog(
                                                          content: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Text('Enter the amount to resurved the food'),
                                                              SizedBox(height: 10,),
                                                              Container(
                                                                child: TextField(
                                                                  controller: controller,
                                                                  decoration: InputDecoration(
                                                                    // label: Text("Quantity"),
                                                                    labelText: "Enter the quantity",
                                                                    helperText: "Current Quantity of food is ${foodCntr.allItems!.value[index].quantity}"
                                                                  ),
                                                                ),
                                                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                                              ),
                                                              SizedBox(height: 10.0,),
                                                              MaterialButton(
                                                                color: Colors.black,
                                                                onPressed: (){
                                                                  WarningDialog(
                                                                      context: context,
                                                                      title:
                                                                      "Do You Want To Resurved this Food of Quantity ${controller.text.trim()}",
                                                                      onYes: () async {
                                                                        if(isGreater(controller.text.trim(),foodCntr.allItems!.value[index].quantity)){
                                                                          print(foodCntr.allItems!.value[index].postBy);
                                                                          RequestedFoodServices().registerItem(food: foodCntr.allItems!.value[index].itemId,by: FirebaseAuth.instance.currentUser?.email!=null?FirebaseAuth.instance.currentUser?.email:needyCntr.user!.value.email,quantity: controller.text.trim(),requestedTo: foodCntr.allItems!.value[index].postBy,index: index,lat: needyCntr.user?.value.latitude,lng: needyCntr.user?.value.longitude);
                                                                        }
                                                                      });
                                                                },child: Text('Submit',style: TextStyle(color: Colors.white),),)
                                                            ],
                                                          ),
                                                        );
                                                      });

                                                    },
                                                  child: Container(
                                                    padding:
                                                    EdgeInsets.only(top: 5),
                                                    width: 200,
                                                    height: 40,
                                                    child: Center(
                                                      child: Container(
                                                        height: 40,
                                                        width: 170,
                                                        decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .black26,
                                                                offset:
                                                                Offset(0, 10),
                                                                blurRadius: 10.0),
                                                          ],
                                                          color: HexColor('#28282B'),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(20),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'Reserved Food',
                                                            style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),



                                              ],
                                            ),
                                            Positioned(
                                                right: 0.0,
                                                top: 0.0,
                                                child: IconButton(onPressed: () async {
                                                  ChatServices().startAChat("${foodCntr.allItems!.value[index].postBy}","donor");
                                                }, icon: Icon(Icons.chat))),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(),
                                ],
                              )),
                        ),
                      );
                    }else{
                      return SizedBox();
                    }

                  }),
            ),
          ),
        ],
      ),
    ));
  }
  bool isGreater(String? value1,String? value2){

    if(int.parse(value1!)>int.parse(value2!)){
      alertSnackbar('The current Quantity is not avaiable. Please give quantity less then $value2 ');
      return false;
    }else{
      return true;
    }
  }
}
