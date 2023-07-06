import 'package:fdn/pages/widgets/loading.dart';
import 'package:fdn/pages/widgets/snackbar.dart';
import 'package:fdn/pages/widgets/warning.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as h;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../Controllers/foodController.dart';
import '../../Controllers/loading.dart';
import '../../Services/foodServices.dart';
import '../widgets/bottomSheet.dart';
import '../widgets/bottomSheet2.dart';

class FoodUpdateScreen extends StatefulWidget {
  FoodUpdateScreen({Key? key,
    required this.index
  }) : super(key: key);
  int index;

  @override
  State<FoodUpdateScreen> createState() => _ItemUpdateScreenState();
}

class _ItemUpdateScreenState extends State<FoodUpdateScreen> {
  final TextEditingController quantity = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController itemId = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController category = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController location = TextEditingController();

  CroppedFile? _pickedImage;

  late String imageUrl='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Theme.of(context).primaryColor,
                    Theme.of(context).hintColor,
                  ])),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(
              top: 16,
              right: 16,
            ),
            child: Stack(
              children: <Widget>[
                Icon(Icons.notifications),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '5',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.red,
        onPressed: (){
          WarningDialog(
              context: context,
              title:
              "Do You Want To delete ${foodCntr.allItems![widget.index].name}",
              onYes: () async {
                FoodServices().delete(foodCntr.allItems![widget.index]);
                Get.back();
              });

        },child: Icon(Icons.delete_forever,color: Colors.white,),),
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              return !loading()
                  ?  Column(
                children: [
                  // SizedBox(height: 100.0,),
                  GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      imageUrl ='';
                      _showPickUpOptionDialog(
                          context);
                      update();
                    },
                    child: Column(
                      children: [
                        Text("Product Image",style: TextStyle(fontSize: 20.0),),
                        SizedBox(height: 10.0,),
                        Container(
                          margin: EdgeInsets.all(5),
                          height: 150,
                          width: 150,
                          color: Colors.red,
                          child: FutureBuilder(
                              future: firebase_storage.FirebaseStorage.instance.ref('foodimg/${foodCntr.allItems!.value[widget.index].profileImageUrl.toString()}').getDownloadURL(),
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
                  ),
                  SizedBox(height: 20.0,),
                  Container(
                    decoration: BoxDecoration(
                        color: HexColor('#ffffff'),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: HexColor('#28282B'),width: 2.0)
                    ),
                    child: ListTile(
                      title: Text('${foodCntr.allItems![widget.index].name}'),
                      leading: Text("Product Name:"),
                      onTap: (){
                        buildBottomSheet2(context,name,'name',foodCntr.allItems![widget.index],foodCntr.allItems![widget.index].name.toString());
                      },
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Container(
                    decoration: BoxDecoration(
                        color: HexColor('#ffffff'),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: HexColor('#28282B'),width: 2.0)
                    ),
                    child: ListTile(
                      title: Text('${foodCntr.allItems![widget.index].location}'),
                      leading: Text("City:"),
                      onTap: (){
                        buildBottomSheet2(context,description,'location',foodCntr.allItems![widget.index],foodCntr.allItems![widget.index].location.toString());
                      },
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Container(
                    decoration: BoxDecoration(
                        color: HexColor('#ffffff'),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: HexColor('#28282B'),width: 2.0)
                    ),
                    child: ListTile(
                      title: Text('${foodCntr.allItems![widget.index].date}'),
                      leading: Text("Expire Date:"),
                      onTap: (){
                        buildBottomSheet(context,price,'date',foodCntr.allItems![widget.index],foodCntr.allItems![widget.index].date.toString());
                      },
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Container(
                    decoration: BoxDecoration(
                        color: HexColor('#ffffff'),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: HexColor('#28282B'),width: 2.0)
                    ),
                    child: ListTile(
                      title: Text('${foodCntr.allItems![widget.index].quantity}'),
                      leading: Text("Product Quantity:"),
                      onTap: (){
                        buildBottomSheet2(context,quantity,'quantity',foodCntr.allItems![widget.index],foodCntr.allItems![widget.index].quantity.toString());
                      },
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Visibility(
                    visible:foodCntr.allItems![widget.index].resurved==true,
                    child: Container(
                      decoration: BoxDecoration(
                          color: HexColor('#ffffff'),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: HexColor('#28282B'),width: 2.0)
                      ),
                      child: ListTile(
                        title: Text('${foodCntr.allItems![widget.index].resurvedBy}'),
                        leading: Text("Reserved By:"),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        color: Colors.black,
                        onPressed: (){
                          Get.back();
                        },child: Text('Done',style: TextStyle(color: Colors.white),),),
                    ],
                  ),
                ],
              )
                  : LoadingWidget();
            }),
            LoadingWidget(),
          ],
        ),
      ),
    );

  }
  void _showPickUpOptionDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Pick Image from Gallery"),
                onTap: () {
                  _loadPicker(ImageSource.gallery);
                },
              ),
              ListTile(
                title: Text('Take a picture'),
                onTap: () {
                  _loadPicker(ImageSource.camera);
                },
              )
            ],
          ),
        ));
  }

  _loadPicker(ImageSource source) async {
    XFile? picked = await ImagePicker().pickImage(source: source);

    if (picked != null) {
      setState((){
        _cropImage(picked);
      });
      Get.back();
    }
  }

  void _cropImage(XFile picked) async {
    CroppedFile? cropped = (await ImageCropper().cropImage(
        sourcePath: picked.path,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.square
        ]));
    if (cropped != null) {
      setState(() {
        _pickedImage = cropped;
      });

    }
  }
  Future<void> update() async {

    try {
      String uniqueFileName =
      DateTime.now()
          .millisecondsSinceEpoch
          .toString();
      Reference referenceRoot =
      FirebaseStorage.instance
          .ref();
      Reference referenceDirImages =
      referenceRoot
          .child('images');

      Reference
      referenceImageToUpload =
      referenceDirImages
          .child(uniqueFileName);
      if (_pickedImage!.path !=
          null) {
        await referenceImageToUpload
            .putFile(h.File(
            _pickedImage!
                .path));
        imageUrl =
        await referenceImageToUpload
            .getDownloadURL();
        FoodServices()
            .update(
            foodCntr.allItems![widget.index],
            'profileImageUrl',
            imageUrl,'Successfully Changed')
            .then(()
        {snackbar("Done!", "Successfully Uploaded Profile Picture");loading(false);}).onError((error)
        {alertSnackbar("Error $error");loading(false);});
      }
    } catch (error) {
      LoadingWidget();
    }
  }
}
