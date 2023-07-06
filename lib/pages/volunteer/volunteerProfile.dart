import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdn/Controllers/needyController.dart';
import 'package:fdn/Controllers/volunteerController.dart';
import 'package:fdn/pages/common/splash_screen.dart';
import 'package:fdn/pages/widgets/header_widget.dart';
import 'package:fdn/pages/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../Controllers/donorController.dart';
import '../../Controllers/loading.dart';
import '../../Services/Authentication.dart';
import '../Auth/forgot_password_page.dart';
import '../Auth/forgot_password_verification_page.dart';
import '../common/login_page.dart';
import '../common/registration_page.dart';

class VolunteerProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<VolunteerProfilePage> {
  double _drawerIconSize = 24;
  double _drawerFontSize = 17;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Stack(
      children: [
        !loading()
            ?Obx(() => Scaffold(
          appBar: AppBar(
            title: Text(
              "Profile",
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
          ),
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
                        user.email!,
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
                        MaterialPageRoute(builder: (context) => VolunteerProfilePage()),
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
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: 100,
                  child: HeaderWidget(100, false, Icons.house_rounded),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 5, color: Colors.white),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 20,
                              offset: const Offset(5, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "${volunteerCntr.user!.value.name}",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "${volunteerCntr.user!.value.name}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding:
                              const EdgeInsets.only(left: 8.0, bottom: 4.0),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "User Information",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Card(
                              child: Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        ...ListTile.divideTiles(
                                          color: Colors.grey,
                                          tiles: [
                                            ListTile(
                                              contentPadding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 4),
                                              leading: Icon(Icons.my_location),
                                              title: Text("Location"),
                                              subtitle: Text("${volunteerCntr.user!.value.address}"),
                                            ),
                                            ListTile(
                                              leading: Icon(Icons.email),
                                              title: Text("Email"),
                                              subtitle:
                                              Text("${volunteerCntr.user!.value.email}"),
                                            ),
                                            ListTile(
                                              leading: Icon(Icons.phone),
                                              title: Text("Phone"),
                                              subtitle: Text("${volunteerCntr.user!.value.contactNo}"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ))
            :LoadingWidget(),
        LoadingWidget(),
      ],
    );
  }
}
