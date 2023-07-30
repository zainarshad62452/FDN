import 'dart:async';

import 'package:fdn/Controllers/needyController.dart';
import 'package:fdn/pages/Donor/postfood.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:fdn/main.dart';
import '../../Controllers/donorController.dart';
import '../../Controllers/foodController.dart';
import '../../Controllers/loading.dart';
import '../../Controllers/requestedFoodController.dart';
import '../../Controllers/volunteerController.dart';
import '../../Services/ChatServices.dart';
import '../../Services/RequestedFoodServices.dart';
import '../../Services/foodServices.dart';
import '../Donor/FoodDetailsUpdateScreen.dart';
import '../common/carouselSlider.dart';
import '../common/locationScreen.dart';
import '../common/theme_helper.dart';
import '../common/volunteerLocationScreen.dart';
import '../widgets/header_widget.dart';
import 'package:fdn/Services/storage_service.dart';

class AllReservedFoodPage extends StatelessWidget {
  AllReservedFoodPage({Key? key}) : super(key: key);

  final DateFormat formatter = DateFormat('dd,MMMM,yyyy');
  final Storage storage = Storage();

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
      child: Container(
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
            Column(
              children: [
                SizedBox(height: 300.0,),
                Column(
                  children: List.generate(
                      requestedFoodCntr.allItems!.value.length!, (index1) {
                    int index = requestedFoodCntr.allItems![index1].index!;
                    print(needyCntr.user?.value.email);

                      var food = foodCntr.allItems!.value[requestedFoodCntr.allItems![index1].index!];
                      print(index);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                                height: 300,
                                decoration: BoxDecoration(
                                    color: HexColor('#fffff'),
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
                                              food.profileImageUrl.toString()),
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
                                                        Text('${food.name}'),
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
                                                        Text('${requestedFoodCntr.allItems!.value[index1].quantity}'),
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
                                                        Text('${food.phone}'),
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
                                                        Text('${formatter.format(food.date!)} \n ${DateFormat.jm().format(food.date!)}'),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 150,
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
                                                        Text('${requestedFoodCntr.allItems!.value[index1].reservedStatus=='${foodStatus.willDeliverByVolunteer}'?'Deliver by volunteer':'Pending Request'}'),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap:(){
                                                      print('geo');
                                                      Get.to(()=> VolunteerLocationScreen(foodLat: LatLng(food.latitude!.toDouble(),food.longitude!.toDouble(),), needyLat: LatLng(requestedFoodCntr.allItems!.value[index1].reservedLatitude!.toDouble(), requestedFoodCntr.allItems!.value[index1].reservedLongitude!.toDouble()),));
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

                          ],
                        ),
                      );


                      // BuildItems(food: foodCntr.allItems!.first);
                    }
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),);;
  }
}
