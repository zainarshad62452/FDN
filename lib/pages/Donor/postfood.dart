import 'package:fdn/Controllers/loading.dart';
import 'package:fdn/Services/NotificationServices.dart';
import 'package:fdn/Services/storage_service.dart';
import 'package:fdn/pages/widgets/header_widget.dart';
import 'package:fdn/pages/widgets/loading.dart';
import 'package:fdn/pages/widgets/snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import '../../Services/foodServices.dart';
import '../common/theme_helper.dart';
import 'dashboard.dart';

class Postfood extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PostfoodState();
  }
}

class _PostfoodState extends State<Postfood> {
  var img_path;
  var img_name;
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;

  final namecontroller = TextEditingController();
  final quantitycontroller = TextEditingController();
  final locationcontroller = TextEditingController();
  final phonecontroller = TextEditingController();
  final datecontroller = TextEditingController();
  final urlimg = TextEditingController();
  Rx<String> selectedDate = ''.obs;
  Rx<DateTime> selectedDateTo = DateTime.now().obs;
  Rx<String> locationText = 'Not Selected'.obs;
  Rx<String> imageText = 'Not Selected'.obs;
  late Position currentPosition;
  Rx<Color> color = Colors.red.obs;
  Rx<Color> imgcolor = Colors.red.obs;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        initialEntryMode:  DatePickerEntryMode.calendar,
        lastDate: DateTime(2101));
    if (picked != null){
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        final selected = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute);

        String hourMinuteAmPm = DateFormat.jm().format(selected);
      final DateFormat formatter = DateFormat('dd,MMMM,yyyy');
      selectedDate.value = formatter.format(picked)+" "+hourMinuteAmPm;
      selectedDateTo.value = selected;
      print(selected);
    }

    }
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 150,
              child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 70,
                        ),
                        GestureDetector(
                          child: Stack(
                            children: [],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFormField(
                            controller: namecontroller,
                            decoration: ThemeHelper().textInputDecoration(
                                'Food Name', 'Enter food name'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFormField(
                            controller: quantitycontroller,
                            decoration: ThemeHelper().textInputDecoration(
                                'Quantity', 'Enter food quantity'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: locationcontroller,
                            decoration: ThemeHelper().textInputDecoration(
                                "Location", "Select your location"),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (!(val!.isEmpty) &&
                                  !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                      .hasMatch(val)) {}
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: phonecontroller,
                            decoration: ThemeHelper().textInputDecoration(
                                "Mobile Number", "Enter your mobile number"),
                            keyboardType: TextInputType.phone,
                            initialValue: "+92",
                            validator: (val) {
                              if (!(val!.isEmpty) &&
                                  !RegExp(r"^\+92\d{10}$").hasMatch(val)) {
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Obx(() => Text('${selectedDate.value}')),
                              MaterialButton(
                                color: Colors.white54,
                                onPressed: (){
                                _selectDate(context);
                              },child: Text('Select Expiry Date'),)
                            ],
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Obx(() => Text('${imageText.value}',style: TextStyle(color: imgcolor.value),)),
                            Container(
                                child: ElevatedButton(
                                    onPressed: (() async {
                                      final results =
                                          await FilePicker.platform.pickFiles(
                                        allowMultiple: false,
                                        type: FileType.custom,
                                        allowedExtensions: ['png', 'jpg'],
                                      );

                                      if (results == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('No file selected.'),
                                          ),
                                        );
                                        return null;
                                      }

                                      final path = results.files.single.path!;
                                      imageText.value = 'Done';
                                      imgcolor.value = Colors.green;
                                      final fileName = results.files.single.name;
                                      img_path = fileName;
                                      img_name = fileName;

                                      storage
                                          .uploadFile(path, fileName)
                                          .then((value) => print('Done'));
                                    }),
                                    child: Text('Upload Image'))),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Obx(() => Text('${locationText.value}',style: TextStyle(color: color.value),)),
                            Container(
                                child: ElevatedButton(
                                    onPressed: (() async {
                                      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
                                      Geolocator.requestPermission();
                                      if (!serviceEnabled) {
                                        alertSnackbar("Please Turn on Your Location");
                                        await Geolocator.requestPermission();
                                      } else {
                                        try {
                                          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                                          currentPosition= position;
                                          locationText.value = 'Done';
                                          print(currentPosition.latitude);
                                          print(currentPosition.longitude);
                                          color.value = Colors.green;

                                        } on Exception catch (e) {
                                          print(e);
                                        }
                                      }
                                    }),
                                    child: Text('Give Food Location'))),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        SizedBox(height: 20.0),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "POST FOOD".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {
                              if(formValidation()){
                                FoodServices().registerItem(name: namecontroller.text, itemPic: img_path,quantity:quantitycontroller.text,location:  locationcontroller.text,phone: phonecontroller.text,date: selectedDateTo.value,latitude: currentPosition.latitude,longitude: currentPosition.longitude);
                                NotificationServices().sendPushMessageTopic();
                                if (_formKey.currentState!.validate()) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => Dashboard()),
                                          (Route<dynamic> route) => false);
                                }
                              }

                            },
                          ),
                        ),
                        SizedBox(height: 30.0),
                        SizedBox(height: 25.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  bool formValidation(){
    if(namecontroller.text.isEmpty){
      alertSnackbar('Name is Required');
      return false;
    }else if(quantitycontroller.text.isEmpty){
      alertSnackbar('Quantity is Mandatory');
      return false;
    }else if(locationcontroller.text.isEmpty){
      alertSnackbar('City is Required');
      return false;
    }else if(phonecontroller.text.isEmpty){
      alertSnackbar('Phone Number is Required');
      return false;
    }else if(selectedDate.value == ''){
      alertSnackbar('Please Select the Date');
      return false;
    }else if(locationText.value=='Not Selected'){
      alertSnackbar('Please give the Location');
      return false;
    }else if(imageText.value == 'Not Selected'){
      alertSnackbar('Please Selected the Image');
      return false;
    }else if(!RegExp(r"^[a-zA-Z\s]+$").hasMatch(namecontroller.text)){
      alertSnackbar('Invalid Food Name. Only letters and spaces are allowed.');
      return false;
    }else if(!RegExp(r"^\d+$").hasMatch(quantitycontroller.text)){
      alertSnackbar('Invalid Quantity. Only numbers are allowed.');
      return false;
    }else if(!RegExp(r"^\+92\d{10}$").hasMatch(phonecontroller.text)){
      alertSnackbar('Invalid Phone Number. Please enter a valid phone number starting with +92.');
      return false;
    }else{
      return true;
    }
  }

}

