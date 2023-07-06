import 'package:fdn/Controllers/loading.dart';
import 'package:fdn/pages/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import '../../Controllers/chatController.dart';
import '../../Models/ChatModel.dart';
import '../../Services/ChatServices.dart';
import '../widgets/customAppBar.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key,required this.reciver,required this.groupChatId}) : super(key: key);

  String reciver;
  String groupChatId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController controller = TextEditingController();
  var userEmail = FirebaseAuth.instance.currentUser?.email;
  ScrollController _scrollController = ScrollController();
  void dispose() {
    Get.delete<ChatController>();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        !loading()
        ? Scaffold(
          appBar: customAppBar(context, "ChatScreen", false),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<List<ChatModel>>(
                  stream: ChatServices().streamAllMessages(widget.groupChatId),
                  builder: (ctx,index){
                    if(index.hasError){
                      print(index.error);
                      return Text('${index.error}');
                    }else if(index.data!=null){
                      var data = index.data;
                      return Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                            itemCount: data?.length,
                            itemBuilder: (ctx,index){
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: data?[index].idFrom== userEmail?CrossAxisAlignment.end:CrossAxisAlignment.start,
                                  children: [
                                    Text('${data?[index].idFrom}',style: TextStyle(color: Colors.black54,fontSize: 10.0),),
                                    Material(
                                      elevation: 5.0,
                                      color: data?[index].idFrom== userEmail?HexColor('#28282B'):Colors.white54,
                                      borderRadius: data?[index].idFrom== userEmail?BorderRadius.only(topLeft: Radius.circular(30.0),bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0) ):BorderRadius.only(topRight: Radius.circular(30.0),bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0) ),
                                      child:Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${data?[index].content}',style: TextStyle(color: data?[index].idFrom== userEmail?Colors.white:Colors.black,fontSize: 5.0.w),),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      );

                    }else{
                      return SizedBox();
                    }

                  }),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Your Message Here....',
                    suffixIcon: IconButton(
                        onPressed: (){
                          if(controller.text.isEmpty){
                            ChatServices().sendMessage(reciver: widget.reciver, content: 'New Message', groupChatId: widget.groupChatId);
                            SchedulerBinding.instance?.addPostFrameCallback((_) {
                              _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 1),
                                  curve: Curves.fastOutSlowIn);
                            });
                          }else{
                            ChatServices().sendMessage(reciver: widget.reciver, content: controller.text.trim(), groupChatId: widget.groupChatId);
                            controller.clear();
                            SchedulerBinding.instance?.addPostFrameCallback((_) {
                              _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 1),
                                  curve: Curves.fastOutSlowIn);
                            });
                          }
                        }, icon: Icon(Icons.send,color: Colors.black,)),
                  ),
                  controller: controller,
                ),
              ),
            ],
          ),
        )
            :LoadingWidget(),
        LoadingWidget()
      ],
    );
  }
}
// Expanded(
// child: ListView.builder(
// itemCount:chatCntr.allMessages!.length,
// itemBuilder: (ctx,index){
// if(chatCntr.allMessages!.value[index].idFrom==FirebaseAuth.instance.currentUser?.email){
// return Padding(
// padding: const EdgeInsets.all(8.0),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.end,
// children: [
// Text('${chatCntr.allMessages!.value[index].idFrom}',style: TextStyle(color: Colors.black54,fontSize: 10.0),),
// Material(
// color: HexColor('#28282B'),
// borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0),bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0) ),
// child:Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text('${chatCntr.allMessages!.value[index].content}',style: TextStyle(color: Colors.white,fontSize: 5.0.w),),
// ),
// ),
// ],
// ),
// );
// }else{
// return Padding(
// padding: const EdgeInsets.all(8.0),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text('${chatCntr.allMessages!.value[index].idTo}',style: TextStyle(color: Colors.black54,fontSize: 10.0),),
// Material(
// color: Colors.white,
// borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0),bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0) ),
// child:Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text('${chatCntr.allMessages!.value[index].content}',style: TextStyle(color: Colors.black54,fontSize: 5.0.w),),
// ),
// ),
// ],
// ),
// );
// }
// }),
// ),