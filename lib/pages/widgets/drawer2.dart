import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

class CustomNavBar2 extends StatelessWidget {
  const CustomNavBar2({
    Key? key,
    required this.value,
    required PageController controller,
  }) : _controller = controller, super(key: key);

  final RxInt value;
  final PageController _controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      color: Colors.red,
      width: 45.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              color: value.value==0?HexColor('#FFFFFF'):HexColor('#28282B'),
              child: IconButton(onPressed: (){
                value.value = 0;
                _controller.animateToPage(value.value, duration: Duration(milliseconds: 300), curve: Curves.ease);
              }, icon: Icon(value.value==0?Icons.fastfood:Icons.fastfood_outlined,color:value.value==0?HexColor('#28282B'):Colors.white)),
            ),
          ),
          Expanded(
            child: Container(
              color: value.value==1?HexColor('#FFFFFF'):HexColor('#28282B'),
              child: IconButton(onPressed: (){
                value.value = 1;
                _controller.animateToPage(value.value, duration: Duration(milliseconds: 300), curve: Curves.ease);
              }, icon: Icon(value.value==1?Icons.chat:Icons.chat_outlined,color:value.value==1?HexColor('#28282B'):Colors.white)),
            ),
          ),
          Expanded(
            child:Container(
              color: value.value==2?HexColor('#FFFFFF'):HexColor('#28282B'),
              child: IconButton(onPressed: (){
                value.value = 2;
                _controller.animateToPage(value.value, duration: Duration(milliseconds: 300), curve: Curves.ease);
              }, icon: Icon(value.value==2?Icons.handshake:Icons.handshake_outlined,color:value.value==2?HexColor('#28282B'):Colors.white)),
            ),
          ),
        ],
      ),
    ));
  }
}