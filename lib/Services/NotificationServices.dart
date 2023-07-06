import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class NotificationServices{

  Future<void> sendPushMessage(String token,String body, String title) async {
    try{
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-type' : 'application/json',
          'Authorization' : 'key=AAAALEG2Akw:APA91bEiSsw2SGqAxSehf6ZjGgEMD1aDpIcnXsjfur4xpYdg-RoWxNaJLe6ZSXnGhHL6EZZy9rbyol3lryS_bGKysKdfwSxacRhU2lvzOaarXtpMNnpgs3hMXzE_qAfevlav3kxHOecc'
        },
        body: jsonEncode(<String, dynamic>{
          'priority' : 'high',
          'data' : <String, dynamic>{
            'click_action' : 'FLUTTER_NOTIFICATION_CLICK',
            'status' : 'done',
            'body': body,
            'title' : title,
          },
          "notification" : <String, dynamic>{
            "title" : title,
            "body" : body,
            "android_channel_id" : "feedtheneedy"
          },
          "to": token
        }),
      );
    }catch(e){
      print('this is push notification error $e');
    }
  }
  Future<void> sendPushMessageTopic() async {
    try{
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-type' : 'application/json',
          'Authorization' : 'key=AAAALEG2Akw:APA91bEiSsw2SGqAxSehf6ZjGgEMD1aDpIcnXsjfur4xpYdg-RoWxNaJLe6ZSXnGhHL6EZZy9rbyol3lryS_bGKysKdfwSxacRhU2lvzOaarXtpMNnpgs3hMXzE_qAfevlav3kxHOecc'
        },
        body: jsonEncode(<String, dynamic>{
          'priority' : 'high',
          'data' : <String, dynamic>{
            'click_action' : 'FLUTTER_NOTIFICATION_CLICK',
            'status' : 'done',
            'body': 'A new food is arrived, click to check-out',
            'title' : 'New Food',
          },
          "notification" : <String, dynamic>{
            "title" : 'New Food',
            "body" : 'A new food is arrived, click to check-out',
            "android_channel_id" : "feedtheneedy"
          },
          "to": '/topics/allneedy'
        }),
      );
    }catch(e){
      print('this is push notification error $e');
    }
  }
  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings =  await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('User permission Granted');
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print('User granted provisional Permission');
    }else{
      print('User denied permission');
    }
  }

  Future<void> getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) async {
      await FirebaseFirestore.instance.collection('donor').doc(FirebaseAuth.instance.currentUser!.uid).update({'token': '$token'}).then((value) => print(token));
    } );
  }
  Future<void> getNeedyToken() async {
    await FirebaseMessaging.instance.getToken().then((token) async {
      await FirebaseFirestore.instance.collection('needy').doc(FirebaseAuth.instance.currentUser!.uid).update({'token': '$token'}).then((value) => print(token));
    } );
  }
  Future<void> getVolunteerToken() async {
    await FirebaseMessaging.instance.getToken().then((token) async {
      await FirebaseFirestore.instance.collection('volunteer').doc(FirebaseAuth.instance.currentUser!.uid).update({'token': '$token'}).then((value) => print(token));
    } );
  }

  void initiateMessage(){
    // FirebaseMessaging.instance.getInitialMessage().then(
    //       (value) => setState(
    //         () {
    //       _resolved = true;
    //       initialMessage = value?.data.toString();
    //     },
    //   ),
    // );
    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if(notification!=null && android !=null){
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  color: Colors.black,
                  playSound: true,
                  icon: '@mipmap/ic_launcher',
                )
            )

        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if(notification!=null && android !=null){
        print('Done');
      }
    });
  }

}