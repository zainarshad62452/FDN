import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Controllers/donorController.dart';
import '../../Controllers/foodController.dart';
import '../../Controllers/loading.dart';
import '../../Services/Reception.dart';
import '../Donor/dashboard.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;

  _SplashScreenState() {
    new Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        if(FirebaseAuth.instance.currentUser != null){
          Reception().userReception();
        }else{
          Get.put(FoodController());
          Get.put(LoadingController());
          Get.put(DonorController());
          Get.offAll(() => LoginPage());
        }
      });
    });

    new Timer(Duration(milliseconds: 10), () {
      setState(() {
        _isVisible =
            true; // Now it is showing fade effect and navigating to Login page
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [
            Theme.of(context).hintColor,
            Theme.of(context).primaryColor
          ],
          begin: const FractionalOffset(0, 0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: Duration(milliseconds: 1200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.no_food,color: Colors.white,size: 150,),
            Container(
              height: 240.0,
              width: 240.0,
              child: Center(
                child: Image.asset('images/FEED THE NEEDY.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Mainpage extends StatelessWidget {
  const Mainpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Something went wrong!'));
            } else if (snapshot.hasData) {
              Get.put(FoodController());
              Get.put(DonorController());
              Get.put(LoadingController());
              Get.put(DonorController());
              return Dashboard();
            } else {
              Get.put(FoodController());
              Get.put(DonorController());
              Get.put(LoadingController());
              Get.put(DonorController());
              return LoginPage();
            }
          },
        ),
      );
}
