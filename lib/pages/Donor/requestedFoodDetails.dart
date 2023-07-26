import 'package:fdn/pages/widgets/customAppBar.dart';
import 'package:fdn/pages/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../Controllers/foodController.dart';
import '../../Controllers/loading.dart';
import '../../Models/RequestFoodModel.dart';
import '../../Services/RequestedFoodServices.dart';

class RequestedFoodScreen extends StatelessWidget {
  RequestedFoodScreen({Key? key,
    required this.food,
    required this.isDonor,
    required this.isVolunteer,
  }) : super(key: key);
  RequestFoodModel food;
  bool isDonor;
  bool isVolunteer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,"Requested Food Details",false),
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              return !loading()
                  ?  SingleChildScrollView(
                    child: Column(
                children: [
                    // SizedBox(height: 100.0,),
                    Column(
                      children: [
                        Text("Product Image",style: TextStyle(fontSize: 20.0),),
                        SizedBox(height: 10.0,),
                        Container(
                          margin: EdgeInsets.all(5),
                          height: 150,
                          width: 150,
                          color: Colors.red,
                          child: FutureBuilder(
                              future: firebase_storage.FirebaseStorage.instance.ref('foodimg/${foodCntr.allItems!.value[food.index!.toInt()].profileImageUrl.toString()}').getDownloadURL(),
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
                                  return CircularProgressIndicator();
                                }
                                return Container();
                              }),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0,),
                    customContainer(context,'${foodCntr.allItems![food.index!.toInt()].name}','Product Name:'),
                    SizedBox(height: 20.0,),
                    customContainer(context,'${food.requestedBy}','Requested By:'),
                    SizedBox(height: 20.0,),
                    customContainer(context,'${foodCntr.allItems![food.index!.toInt()].location}','Food Location:'),
                    SizedBox(height: 20.0,),
                    customContainer(context,'${food.requestedOn?.toDate()}','Requested On:'),
                    SizedBox(height: 20.0,),
                    customContainer(context,'${foodCntr.allItems![food.index!.toInt()].quantity}','Food Quantity'),
                    SizedBox(height: 20.0,),
                    customContainer(context,'${food.quantity}','Requested Quantity'),
                    SizedBox(height: 20.0,),
                  customContainer(context,'${food.resurved==true?'Reserved':'Request Pending'}','Food Status'),
                  SizedBox(height: 20.0,),
                    Visibility(
                      visible:(isDonor==true || isVolunteer == true),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            color: HexColor('#28282B'),
                            onPressed: (){
                              isDonor?RequestedFoodServices().accept('${food.uid}', '${foodCntr.allItems![food.index!.toInt()].itemId}','${int.parse(foodCntr.allItems![food.index!.toInt()].quantity!) - int.parse(food.quantity.toString())}','${food.requestedUid}'):isVolunteer?RequestedFoodServices().acceptedByVolunteer('${food.uid}', '${food.requestedUid}',true):print("");
                            },child: Text('Approve',style: TextStyle(color: Colors.white),),),
                          MaterialButton(
                            color: HexColor('#28282B'),
                            onPressed: (){
                              print('de aprrovoing');
                            },child: Text('Reject',style: TextStyle(color: Colors.white),),),
                        ],
                      ),
                    ),
                ],
              ),
                  )
                  : LoadingWidget();
            }),
            LoadingWidget(),
          ],
        ),
      ),
    );

  }

  Widget customContainer(BuildContext context,String? text,String? title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0,right: 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: HexColor('#ffffff'),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: HexColor('#28282B'),width: 2.0)
        ),
                    child: ListTile(
                      title: Text('$text'),
                      leading: Text("$title"),
                    ),
                  ),
    );
  }
}
