import 'package:fdn/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fdn/Services/storage_service.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../Controllers/foodController.dart';
import '../../Controllers/volunteerController.dart';
import '../../Services/ChatServices.dart';
import '../../Services/foodServices.dart';
import '../widgets/snackbar.dart';
import 'locationScreen.dart';


class BuildItems extends StatelessWidget {
  BuildItems({Key? key,required this.food}) : super(key: key);

  final DateFormat formatter = DateFormat('dd,MMMM,yyyy');
  final Storage storage = Storage();
  var food;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
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
                                      Text('${food.quantity}'),
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
                                      Text('${food.reservedStatus=='${foodStatus.readyToCollect}'?'Ready To Collect':food.reservedStatus=='${foodStatus.willDeliverByVolunteer}'?'Deliver By You':food.reservedStatus=='${foodStatus.requestToVolunteer}'?'Requested To You':food.reservedStatus=='${foodStatus.collected}'?"Delivered":'Pending Request'}'),
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
                                  visible: food.reservedStatus == "${foodStatus.willDeliverByVolunteer}" && FirebaseAuth.instance.currentUser?.email == volunteerCntr.user?.value.email,
                                  child: GestureDetector(
                                    onTap:(){
                                      print('geo');
                                      if(food.reservedLatitude!=null){
                                        Get.to(()=> LocationScreen(latitude: food.reservedLatitude!.toDouble(),longitude: food.reservedLongitude!.toDouble(),));

                                      }else{
                                        alertSnackbar("Needy has not given the Location");
                                      }
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
                                              'View Needy Location',
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
                                Visibility(
                                  visible: food.reservedStatus=='${foodStatus.readyToCollect}',
                                  child: MaterialButton(
                                    onPressed: (){
                                      showDialog(context: context, builder: (ctx){
                                        return AlertDialog(
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
                                                        FoodServices().update(foodCntr.allItems!.value[index], 'reservedStatus', '${foodStatus.requestToVolunteer}','Successfully Sent Request to Volunteer');
                                                        FoodServices().update(foodCntr.allItems!.value[index], 'requestedVolunteer', '${volunteerCntr.allUsers!.value[index].email}','Successfully Sent Request to Volunteer');
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
                                Visibility(
                                  visible: food.reservedStatus == "${foodStatus.willDeliverByVolunteer}" && FirebaseAuth.instance.currentUser?.email == volunteerCntr.user?.value.email,
                                  child: GestureDetector(
                                    onTap:(){
                                      FoodServices().update(food, 'reservedStatus', '${foodStatus.collected}', "You have successfully delivered the Food.");
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
                                              'Delivered',
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
          Positioned(
              right: 0.0,
              top: 0.0,
              child: IconButton(onPressed: () async {
                ChatServices().startAChat("${food.resurvedByUid}","needy");
              }, icon: Icon(Icons.chat))),
        ],
      ),
    );
  }
}
