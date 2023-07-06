import 'package:fdn/pages/Auth/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fdn/pages/common/login_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Auth/forgot_password_page.dart';
import '../Donor/profile_page.dart';
import 'registration_page.dart';
import '../widgets/header_widget.dart';

class Loginas extends StatefulWidget {
  const Loginas({Key? key,}) : super(key: key);
  @override
  _LoginasState createState() => _LoginasState();
}

class _LoginasState extends State<Loginas> {
  double _headerHeight = 250;
  Key _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true,
                  Icons.login_rounded), //let's create a common header widget
            ),
            SafeArea(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: EdgeInsets.fromLTRB(
                      20, 10, 20, 10), // This will be the login form
                  child: Column(
                    children: [
                      Text(
                        'Hello',
                        style: TextStyle(
                            fontSize: 60, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Signup account as',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(height: 15.0),
                              Container(
                                height: 50,
                                width: 180,
                                decoration: BoxDecoration(
                                  color: HexColor('#28282B'),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 8),
                                        blurRadius: 5.0)
                                  ],
                                ),
                                child: Center(
                                  child: Text.rich(TextSpan(children: [
                                    TextSpan(
                                        text: 'DONER',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = ()=> Get.to(()=>SignupPage( isDonor: true,isVolunteer: false,)),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white,
                                        )),
                                  ])),
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Container(
                                height: 50,
                                width: 180,
                                decoration: BoxDecoration(
                                  color: HexColor('#28282B'),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 8),
                                        blurRadius: 5.0)
                                  ],
                                ),
                                child: Center(
                                  child: Text.rich(TextSpan(children: [
                                    TextSpan(
                                        text: 'NEEDER',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = ()=> Get.to(()=>SignupPage( isDonor: false,isVolunteer: false,)),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white,
                                        )),
                                  ])),
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Container(
                                height: 50,
                                width: 180,
                                decoration: BoxDecoration(
                                  color: HexColor('#28282B'),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 8),
                                        blurRadius: 5.0)
                                  ],
                                ),
                                child: Center(
                                  child: Text.rich(TextSpan(children: [
                                    TextSpan(
                                        text: 'Volunteer',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = ()=> Get.to(()=>SignupPage( isDonor: false,isVolunteer: true,)),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white,
                                        )),
                                  ])),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                //child: Text('Don\'t have an account? Create'),
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(text: "Already have an account? "),
                                  TextSpan(
                                    text: 'Login',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginPage()),
                                                (route) => false);
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).hintColor),
                                  ),
                                ])),
                              ),
                            ],
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
