import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdn/Controllers/donorController.dart';
import 'package:fdn/Controllers/needyController.dart';
import 'package:fdn/Controllers/requestedFoodController.dart';
import 'package:fdn/Services/RequestedFoodServices.dart';
import 'package:fdn/main.dart';
import 'package:fdn/pages/Donor/requestedFoodDetails.dart';
import 'package:fdn/pages/common/locationScreen.dart';
import 'package:fdn/pages/Donor/postfood.dart';
import 'package:fdn/pages/Donor/profile_page.dart';
import 'package:fdn/pages/Donor/FoodRequestsScreen.dart';
import 'package:fdn/pages/common/splash_screen.dart';
import 'package:fdn/Services/storage_service.dart';
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
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../Controllers/foodController.dart';
import '../../Controllers/loading.dart';
import '../../Services/NotificationServices.dart';
import '../../Services/foodServices.dart';
import '../common/NavigationBar.dart';
import '../common/chatPage.dart';
import '../widgets/drawer2.dart';
import 'AllFoodPage.dart';
import 'ChatScreen.dart';
import 'FoodDetailsUpdateScreen.dart';
import '../common/theme_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'PostedFoodPage.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  var value = 0.obs;
  late NotificationServices notificationServices;
  @override
  void initState() {
    super.initState();
    notificationServices = NotificationServices();
    notificationServices.requestPermission();
    notificationServices.getToken();
    notificationServices.initiateMessage();
  }

  PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Dashboard", true),
      drawer: NavBarDrawer(),
      bottomNavigationBar: CustomNavBar2(value: value, controller: _controller),
      body: Stack(
        children: [
          PageView(
            controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
            children: [
              // AllFoodPage(),
              PostedFoodPage(),
              ChatPage(),
              RequestsPage(),
            ],
          ),
          LoadingWidget(),
        ],
      ),
    );
  }
}
