import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdn/Models/needyModel.dart';
import 'package:fdn/Services/needyServices.dart';
import 'package:fdn/main.dart';
import 'package:fdn/pages/widgets/customAppBar.dart';
import 'package:fdn/pages/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../Controllers/foodController.dart';
import '../../Controllers/loading.dart';
import '../../Models/RequestFoodModel.dart';
import '../../Models/foodModel.dart';
import '../../Services/RequestedFoodServices.dart';

class RequestedFoodScreen2 extends StatelessWidget {
  RequestedFoodScreen2({Key? key,
    required this.food,
    required this.isDonor,
  }) : super(key: key);
  FoodModel food;
  bool isDonor;

  
  
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
                              future: firebase_storage.FirebaseStorage.instance.ref('foodimg/${food.profileImageUrl.toString()}').getDownloadURL(),
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
                    customContainer(context,'${food.name}','Product Name:'),
                    SizedBox(height: 20.0,),
                    customContainer(context,'${food.resurvedBy}','Requested By:'),
                    SizedBox(height: 20.0,),
                    customContainer(context,'${food.location}','Food Location:'),
                    SizedBox(height: 20.0,),
                    customContainer(context,'${food.date}','Expiry Date'),
                    SizedBox(height: 20.0,),
                    customContainer(context,'${food.quantity}','Food Quantity'),
                    SizedBox(height: 20.0,),
                    customContainer(context,'${food.resurved==true?'Reserved':'Request Pending'}','Food Status'),
                    SizedBox(height: 20.0,),
                    Visibility(
                      visible:isDonor==false && food.reservedStatus == "${foodStatus.requestToVolunteer}",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            color: HexColor('#28282B'),
                            onPressed: (){
                              RequestedFoodServices().acceptedByVolunteer('${food.itemId}', '${food.resurvedByUid}',true);
                              print(food.itemId);
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
