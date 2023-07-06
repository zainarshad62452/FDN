import 'package:fdn/Controllers/loading.dart';
import 'package:fdn/pages/Donor/FoodRequestsScreen.dart';
import 'package:fdn/pages/volunteer/volunteerDashbord.dart';
import 'package:fdn/pages/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sizer/sizer.dart';
import 'Controllers/donorController.dart';
import 'Controllers/foodController.dart';
import 'Controllers/needyController.dart';
import 'Controllers/newChatController.dart';
import 'Controllers/requestedFoodController.dart';
import 'Controllers/volunteerController.dart';
import 'pages/common/splash_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  showFlutterNotification(message);
  print('Handling a background message ${message.messageId}');
}

late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;
enum foodStatus { readyToCollect, collected, requestToVolunteer, rejected, pending,willDeliverByVolunteer}

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);


  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'launch_background',
          playSound: true,
          enableVibration: true,
          enableLights: true,
        ),
      ),
    );
  }
}

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
Future main() async {
  Get.put(RequestedFoodController());
  Get.put(FoodController());
  Get.put(NewChatController());
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(LoadingController());

  await Firebase.initializeApp();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  };
  runApp(LoginUiApp());
  FirebaseAuth.instance.currentUser!.sendEmailVerification();
}

final navigatorKey = GlobalKey<NavigatorState>();

class LoginUiApp extends StatelessWidget {
  Color _primaryColor = HexColor('#28282B');
  Color _hintColor = HexColor('#171717');
  // Design color
  // Color _primaryColor= HexColor('#FFC867');
  // Color _hintColor= HexColor('#FF3CBD');

  // Our Logo Color
  // Color _primaryColor= HexColor('#D44CF6');
  // Color _hintColor= HexColor('#5E18C8');

  // Our Logo Blue Color
  // Color _primaryColor= HexColor('#651BD2');
  // Color _hintColor= HexColor('#320181');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: ((context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'Feed The Needy',
        theme: ThemeData(
          primaryColor: _primaryColor,
          hintColor: _hintColor,
          scaffoldBackgroundColor: Colors.grey.shade100,
          primarySwatch: Colors.grey,
        ),
        home: SplashScreen(
          title: 'Do Eat',
        ),
      );
    }));

  }
}
