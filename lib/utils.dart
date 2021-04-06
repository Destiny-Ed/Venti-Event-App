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

class TelephoneSms {
  final Telephony telephony = Telephony.instance;

  sendSms({String to, String message}) async {
    telephony.sendSms(
        to: to,
        message: message,
        statusListener: (status) {
          return status;
        });
  }

}
