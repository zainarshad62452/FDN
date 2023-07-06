import 'package:fdn/Controllers/donorController.dart';
import 'package:fdn/Controllers/volunteerController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Controllers/chatController.dart';
import '../../Controllers/needyController.dart';
import '../../Controllers/newChatController.dart';
import '../../Services/newChatServices.dart';
import '../Donor/ChatScreen.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool show = false;

  String getName(String? email){
    String name = "";
    var donors = donorCntr.allUsers!.value;
    var needy = needyCntr.allUsers!.value;
    var volunteer = volunteerCntr.allUsers!.value;
    if(donors.length != 0){
      for(var donor in donors){
        if(email == donor.email){
          return name = donor.name!;
        }
      }
    }
    if(needy.length != 0){
      for(var donor in needy){
        if(email == donor.email){
          return name = donor.name!;
        }
      }
    }
    if(volunteer.length != 0){
      for(var donor in volunteer){
        if(email == donor.email){
          return name = donor.name!;
        }
      }
    }

    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() => Padding(
          padding: const EdgeInsets.only(top:50.0),
          child: Container(
            child: ListView.builder(
                itemCount: newChatCntr.allUsers?.length,
                itemBuilder: (ctx,index){
                  if(newChatCntr.allUsers!.value[index].user1 == FirebaseAuth.instance.currentUser?.email || newChatCntr.allUsers!.value[index].user2 == FirebaseAuth.instance.currentUser?.email) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  child: Text(
                                      "${'${newChatCntr.allUsers?.value[index].user1 == FirebaseAuth.instance.currentUser!.email ? '${getName(newChatCntr.allUsers?.value[index].user2)==""?"U":getName(newChatCntr.allUsers?.value[index].user2)[0]?.capitalize}' : '${getName(newChatCntr.allUsers?.value[index].user2)==""?"U":getName(newChatCntr.allUsers?.value[index].user1)[0]?.capitalize}'}'}"),
                                ),
                                onTap: () {
                                  Get.put(ChatController(
                                      reciver:
                                          '${newChatCntr.allUsers?.value[index].groupID}'));
                                  Get.to(() => ChatScreen(
                                        reciver:
                                            '${newChatCntr.allUsers?.value[index].user1 == FirebaseAuth.instance.currentUser?.email ? '${newChatCntr.allUsers?.value[index].user2}' : '${newChatCntr.allUsers?.value[index].user1}'}',
                                        groupChatId:
                                            '${newChatCntr.allUsers?.value[index].groupID}',
                                      ));
                                },
                                title: Text(
                                    '${newChatCntr.allUsers?.value[index].user1 == FirebaseAuth.instance.currentUser?.email ? '${getName(newChatCntr.allUsers?.value[index].user2)}' : '${getName(newChatCntr.allUsers?.value[index].user1)}'}'),
                              ),
                              Visibility(
                                visible: show==true,
                                child: IconButton(onPressed: (){
                                  show = false;
                                  NewChatServices().delete(newChatCntr.allUsers!.value[index]!);
                                  setState(() {

                                  });
                                  print("delete");
                                }, icon: Icon(Icons.delete_forever,color: Colors.red,)),
                              )
                            ],
                          ),
                        ),
                      );
                    } else return SizedBox();
                }),
          ),
        ),),
        Positioned(
            bottom: 15.5,
            right:  15.5,
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: (){
                showDialog(context: context, builder: (ctx){
                  return AlertDialog(
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: listUser(),
                      ),
                    ),
                  );
                });
              },child: Center(child: Text('New Chat')),)),
        Visibility(
          visible: !show,
          child: ListTile(
            tileColor: Colors.black,
            leading: Text("Delete Chat",style: TextStyle(color: Colors.white),),
            trailing: Icon(Icons.delete_forever,color: Colors.red,),
            onTap: () {
              show = true;
              setState(() {

              });
            },
          ),
        )
      ],
    );
  }

  List<Widget> listUser(){
    var donors = donorCntr.allUsers;
    var needys = needyCntr.allUsers;
    var volunteers = volunteerCntr.allUsers;
    List<Widget> list = [];

    for(var donor in donors!){
      if(donor.email != FirebaseAuth.instance.currentUser?.email)
      list.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration:BoxDecoration(
            border: Border.all(color: Colors.black,width: 2.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: Text('${donor.email}'),
            onTap: (){
              NewChatServices().startChat('${donor.email}', '${FirebaseAuth.instance.currentUser?.email}');
            },
          ),
        ),
      ));
    }
    for(var needy in needys!){
      if(needy.email != FirebaseAuth.instance.currentUser?.email)
      list.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration:BoxDecoration(
            border: Border.all(color: Colors.black,width: 2.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: Text('${needy.email}'),
            onTap: (){
              NewChatServices().startChat('${needy.email}', '${FirebaseAuth.instance.currentUser?.email}');

            },
          ),
        ),
      ));
    }
    for(var volunteer in volunteers!){
      if(volunteer.email != FirebaseAuth.instance.currentUser?.email)
      list.add(
          Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration:BoxDecoration(
            border: Border.all(color: Colors.black,width: 2.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: Text('${volunteer.email}'),
            onTap: (){
              NewChatServices().startChat('${volunteer.email}', '${FirebaseAuth.instance.currentUser?.email}');

            },
          ),
        ),
      ));
    }
    return list;

  }
}