import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../common/NavigationBar.dart';

AppBar customAppBar(BuildContext context,String? title,bool? showNotification,) {
  return AppBar(
    title: Text(
      "$title",
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
  );
}