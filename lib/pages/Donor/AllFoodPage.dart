import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../Controllers/foodController.dart';
import '../../Services/foodServices.dart';
import '../common/locationScreen.dart';
import '../widgets/header_widget.dart';
import 'package:fdn/Services/storage_service.dart';

class AllFoodPage extends StatelessWidget {
  AllFoodPage({Key? key}) : super(key: key);

  final DateFormat formatter = DateFormat('dd,MMMM,yyyy');
  final Storage storage = Storage();
  @override
  Widget build(BuildContext context) {

      return Obx(() =>Container(
        child: Stack(
          children: [
            Container(
              height: 100,
              child: HeaderWidget(100, false, Icons.house_rounded),
            ),
            Container(
              padding: EdgeInsets.only(top: 100),
              child: ListView.builder(
                  padding: EdgeInsets.all(5),
                  itemCount: foodCntr.allItems?.value.length,
                  itemBuilder: (context, index) {
                    var remainingTime = foodCntr.allItems![index].date!.difference(DateTime.now());
                    Timer.periodic(Duration(minutes: 10), (timer) {
                      remainingTime = foodCntr.allItems![index].date!.difference(DateTime.now());
                      // print(remainingTime);
                      if (remainingTime.isNegative) {
                        timer.cancel();
                      }
                    });
                    if (!remainingTime.isNegative) {
                      print(remainingTime);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                                color: HexColor('#fffff'),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: HexColor('#28282B'),width: 2.0)
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
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
                                              Expanded(
                                                child: Container(
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
                                              ),
                                              Expanded(
                                                child: Container(
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
                                              ),
                                              Expanded(
                                                child: Container(
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
                                              ),
                                              Expanded(
                                                child: Container(
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
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Status:  ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255, 57, 4, 62),
                                                        ),
                                                      ),
                                                      Text('${foodCntr.allItems!.value[index].resurved==true?'Reserved':'Not Reserved'}')
                                                    ],
                                                  ),
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
                                                      width: 120,
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
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(),
                              ],
                            )),
                      );
                    }else{
                      FoodServices().delete(foodCntr.allItems![index]);
                      return SizedBox();
                    }

                  }),
            ),
          ],
        ),
      ),);
  }
}
