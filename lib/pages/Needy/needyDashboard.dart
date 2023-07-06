import 'package:fdn/Services/needyServices.dart';
import 'package:fdn/pages/widgets/NavBarDrawer.dart';
import 'package:fdn/pages/widgets/customAppBar.dart';
import 'package:fdn/pages/widgets/header_widget.dart';
import 'package:fdn/pages/widgets/loading.dart';
import 'package:fdn/pages/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../Controllers/foodController.dart';
import '../../Controllers/loading.dart';
import '../../Controllers/needyController.dart';
import '../../Services/Authentication.dart';
import '../../Services/NotificationServices.dart';
import '../../Services/foodServices.dart';
import '../Auth/forgot_password_page.dart';
import '../Auth/forgot_password_verification_page.dart';
import '../Donor/ChatScreen.dart';
import '../common/NavigationBar.dart';
import '../common/login_page.dart';
import '../common/registration_page.dart';
import '../common/splash_screen.dart';
import '../common/theme_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'NeedyRequestsPage.dart';
import 'ReservedFoodPage.dart';
import 'allFoodPageForNeedy.dart';
import '../common/chatPage.dart';
import 'needyProfilePage.dart';

class NeedyDashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<NeedyDashboard> {
  var value = 0.obs;
  late NotificationServices notificationServices;
  @override
  void initState() {
    super.initState();
    notificationServices = NotificationServices();
    notificationServices.requestPermission();
    notificationServices.getNeedyToken();
    notificationServices.initiateMessage();
    FirebaseMessaging.instance.subscribeToTopic("allneedy");
  }

  PageController _controller = PageController();
  double _drawerIconSize = 24;
  double _drawerFontSize = 17;
  bool isLocationEnabled = needyCntr.user?.value.longitude==null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Dashboard", false),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [
                    0.0,
                    1.0
                  ],
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.2),
                    Theme.of(context).hintColor.withOpacity(0.5),
                  ])),
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1.0],
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).hintColor,
                    ],
                  ),
                ),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "${FirebaseAuth.instance.currentUser?.email!}",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.screen_lock_landscape_rounded,
                  size: _drawerIconSize,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Splash Screen',
                  style: TextStyle(
                      fontSize: 17, color: Theme.of(context).hintColor),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SplashScreen(title: "Splash Screen")));
                },
              ),
              ListTile(
                leading: Icon(Icons.login_rounded,
                    size: _drawerIconSize,
                    color: Theme.of(context).hintColor),
                title: Text(
                  'Profile',
                  style: TextStyle(
                      fontSize: _drawerFontSize,
                      color: Theme.of(context).hintColor),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NeedyProfilePage()),
                  );
                },
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.login_rounded,
                    size: _drawerIconSize,
                    color: Theme.of(context).hintColor),
                title: Text(
                  'Login Page',
                  style: TextStyle(
                      fontSize: _drawerFontSize,
                      color: Theme.of(context).hintColor),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.person_add_alt_1,
                    size: _drawerIconSize,
                    color: Theme.of(context).hintColor),
                title: Text(
                  'Registration Page',
                  style: TextStyle(
                      fontSize: _drawerFontSize,
                      color: Theme.of(context).hintColor),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()),
                  );
                },
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              ListTile(
                leading: Icon(
                  Icons.password_rounded,
                  size: _drawerIconSize,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Forgot Password Page',
                  style: TextStyle(
                      fontSize: _drawerFontSize,
                      color: Theme.of(context).hintColor),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage()),
                  );
                },
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              ListTile(
                leading: Icon(
                  Icons.verified_user_sharp,
                  size: _drawerIconSize,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Verification Page',
                  style: TextStyle(
                      fontSize: _drawerFontSize,
                      color: Theme.of(context).hintColor),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordVerificationPage()),
                  );
                },
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              ListTile(
                leading: Icon(
                  Icons.logout_rounded,
                  size: _drawerIconSize,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                      fontSize: _drawerFontSize,
                      color: Theme.of(context).hintColor),
                ),
                onTap: () {
                  Authentication().signOut();
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(value: value, controller: _controller),
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              AllFoodPageForNeedy(),
              ReservedFoodPage(),
              ChatPage(),
              NeedyRequestsPage(),
            ],
          ),
          Visibility(
            visible: isLocationEnabled,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
                // border: Border.all(color: Colors.white),
              ),
              height: 40.0,
              width: double.infinity,
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () async {
                        showDialog(context: context, builder: (x){
                          return Dialog(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MaterialButton(onPressed: () async {
                                  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
                                  Geolocator.requestPermission();
                                  if (!serviceEnabled) {
                                    alertSnackbar("Please Turn on Your Location");
                                    await Geolocator.requestPermission();
                                  } else {
                                    try {
                                      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                                      NeedyServices().updateLocation(position.latitude, position.longitude);
                                      setState(() {
                                        isLocationEnabled = false;
                                        Navigator.pop(context);
                                      });
                                    } on Exception catch (e) {
                                      print(e);
                                    }
                                  }
                                },child: Text("Give Location",style: TextStyle(color: Colors.white),),color: Colors.black,)
                              ],
                            ),
                          );
                        });

                      },
                      child: Expanded(child: Center(child: Text("Please Provide your Location",style: TextStyle(color: Colors.white,fontSize: 20.0),)))),
                  IconButton(onPressed: (){
                    setState(() {
                      isLocationEnabled = false;
                      print(isLocationEnabled);
                    });
                  }, icon: Icon(Icons.close,color: Colors.white,))
                ],
              ),
            ),
          ),
          LoadingWidget(),
        ],
      ),
    );
  }
}





