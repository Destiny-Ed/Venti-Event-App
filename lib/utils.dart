import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:telephony/telephony.dart';
import 'package:venti/Screens/MainPages/home_page.dart';

class PageRouter {
  BuildContext context;

  PageRouter(this.context);

  openNextPage({Widget page}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  openNextAndClearPrevious({Widget page}) {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => page), (route) => false);
  }
}

class NotificationClass {
  FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();

  //Initialization
  //
  void initializeNotification() {
    var androidDetails = AndroidInitializationSettings("ic_launcher");
    var iosDetail = IOSInitializationSettings();

    var initAll =
        InitializationSettings(android: androidDetails, iOS: iosDetail);

    localNotification.initialize(initAll);
  }

  //Showing Notification
  void notify({String title, String body}) async {
    var androidDetails = AndroidNotificationDetails("channelId",
        "Venti Notification", "Venti Local Notification for flutter");

    var iosDetails = IOSNotificationDetails();

    var detailsAll =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await localNotification.show(1, title, body, detailsAll);
  }
}

//Trigger Background notification
class TriggerLocalNotification {
  FirebaseAuth _auth = FirebaseAuth.instance;

  void callFunction() async {
    NotificationClass().initializeNotification();
    print(_auth.currentUser.email);

    FirebaseFirestore.instance
        .doc(_auth.currentUser.uid)
        .snapshots()
        .where((event) => event["date"] == DateTime.now())
        .map((DocumentSnapshot event) {
      final String eventName = event.data()["eventName"];
      final String desc = event.data()["description"];
      print(eventName);

      //Show Notification
      NotificationClass().notify(title: eventName, body: desc);
    });
  }
}

class TelephoneSms {
  final Telephony telephony = Telephony.instance;

  sendSms({String to, String message}) async {
    //Request For sms permission
    await telephony.requestSmsPermissions.then((value) {
      print(value);
    });

    telephony.sendSms(
        to: to,
        message: message,
        statusListener: (status) {
          return status;
        });
  }
}
