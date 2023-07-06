import 'package:fdn/pages/widgets/warning.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Controllers/loading.dart';
import '../../Models/foodModel.dart';
import '../../Services/foodServices.dart';


Future<dynamic> buildBottomSheet2(BuildContext context,TextEditingController controller,String index,FoodModel Item,String value) {
return Get.bottomSheet(
  Container(
    height: 250,
    color: Colors.white,
    child:Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Spacer(),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter value',
              contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
            ),
          ),
          Spacer(),
          Material(
            child: MaterialButton(
              highlightColor: Colors.white,
              hoverColor: Colors.red,
              color: Color(0xFF111313),
              onPressed: () {
                if(controller.text!=null){
                  print(controller.text);
                  WarningDialog(
                      context: context,
                      title:
                      "Do You Want To change value $value to ${controller.text.trim()}",
                      onYes: () async {
                        loading(true);
                        FoodServices().update(Item,index, controller.text.trim(),'Successfully Changed');
                        Get.back();
                        loading(true);
                      });
                }else{
                  Get.snackbar(
                    "Alert", "Please Provide a Value",
                    colorText: Colors.white,
                    backgroundColor: Colors.black,
                    icon: Icon(Icons.error,color: Colors.white,),
                  );

                }

              },
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),

        ],
      ),
    )
),
  persistent:true,

    barrierColor: Colors.transparent,
    isDismissible: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
        side: BorderSide(
            width: 5,
            color: Colors.black
        )
    ),
    enableDrag: true,
);
  // return Get.bottomSheet(
  //   persistent:true,
  //  
  //   barrierColor: Colors.transparent,
  //   isDismissible: true,
  //   shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(35),
  //       side: BorderSide(
  //           width: 5,
  //           color: Colors.black
  //       )
  //   ),
  //   enableDrag: true,
  //
  //
  // );
}