import 'package:fdn/Controllers/needyController.dart';
import 'package:fdn/Services/RequestedFoodServices.dart';
import 'package:fdn/main.dart';
import 'package:fdn/pages/common/buildItems.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../Controllers/foodController.dart';
import '../../Controllers/requestedFoodController.dart';
import '../../Controllers/volunteerController.dart';
import '../../Services/foodServices.dart';
import '../common/locationScreen.dart';
import '../widgets/header_widget.dart';
import 'package:fdn/Services/storage_service.dart';
class ReservedFoodPage extends StatelessWidget {
  ReservedFoodPage({Key? key}) : super(key: key);
  final DateFormat formatter = DateFormat('dd,MMMM,yyyy');
  final Storage storage = Storage();
  // var food;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Expanded(
        child: Container(
          child: ListView(
            children: [
              Container(
                height: 100,
                child: HeaderWidget(100, false, Icons.house_rounded),
              ),
              Expanded(
                child: Column(
                  children: List.generate(int.parse('${foodCntr.allItems?.value.length}'), (index)  {
                          if (needyCntr.user!.value.email ==
                                  foodCntr.allItems![index].resurvedBy &&
                              foodCntr.allItems![index].resurved == true) {
                            return BuildItems(food: foodCntr.allItems![index]);
                          } else {
                            return SizedBox();
                          }
                        }),

                  ),
              ),
              Expanded(
                child: Column(
                  children: List.generate(
                      int.parse('${requestedFoodCntr.allItems?.value.length}'), (index1) {
                    int index = int.parse(
                        '${requestedFoodCntr.allItems![index1].index}');
                    print(needyCntr.user?.value.email);
                    if (needyCntr.user?.value.email ==
                    requestedFoodCntr.allItems![index1].requestedBy
                        // &&  requestedFoodCntr.allItems![index1].reservedStatus=='${foodStatus.readyToCollect}'
                    ) {
                      var food = foodCntr.allItems!.value[index];
                print(index);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 200,
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
                                              Text('${food.reservedStatus=='${foodStatus.readyToCollect}'?'Ready To Collect':'Pending Request'}'),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap:(){
                                            print('geo');
                                            Get.to(()=> LocationScreen(latitude: food.latitude!.toDouble(),longitude: food.longitude!.toDouble(),));
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
                                        Visibility(
                                          visible: requestedFoodCntr.allItems!.value[index1].reservedStatus=='${foodStatus.readyToCollect}',
                                          child: MaterialButton(
                                            onPressed: (){
                                              showDialog(context: context, builder: (ctx){
                                                return AlertDialog(
                                                  title: Text("Near by Volunteer"),
                                                  content: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: List.generate(volunteerCntr.allUsers!.length, (index) {
                                                        return Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Container(
                                                            decoration:BoxDecoration(
                                                              border: Border.all(color: Colors.black,width: 2.0),
                                                              borderRadius: BorderRadius.circular(5.0),
                                                            ),
                                                            child: ListTile(
                                                              title: Text('${volunteerCntr.allUsers!.value[index].email}'),
                                                              onTap: (){
                                                                RequestedFoodServices().update(requestedFoodCntr.allItems!.value[index1], 'reservedStatus', '${foodStatus.requestToVolunteer}','Successfully Sent Request to Volunteer');
                                                                RequestedFoodServices().update(requestedFoodCntr.allItems!.value[index], 'requestedVolunteer', '${volunteerCntr.allUsers!.value[index].email}','Successfully Sent Request to Volunteer');
                                                                Get.back();
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    ),
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
                                                      'Request Volunteer',
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
            } else {
                return SizedBox();
            }
                  }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
