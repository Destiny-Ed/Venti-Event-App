import 'dart:io';

import 'package:flutter/material.dart';
import 'package:venti/Screens/splash.dart';
import 'package:venti/utils.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) async {
    print("Starting Alarm Manager Again");
    // TriggerLocalNotification().callFunction();
    //
    try {
      //Firebase
      print("Trying........................................................");
      TriggerLocalNotification().callFunction();
    } on SocketException catch (_) {
      NotificationClass().initializeNotification();

      NotificationClass().notify(
          title: "Venti is always awake",
          body: "Send That Beautiful Event Notification Now");
    } catch (_) {
      NotificationClass().initializeNotification();

      NotificationClass().notify(
          title: "Venti is always awake",
          body: "Send That Beautiful Event Notification Now");
    }

    //
    print("Task $taskName Data $inputData");

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Workmanager.initialize(callbackDispatcher);

  await Workmanager.registerOneOffTask("tytytygh", "ventiTask",
      inputData: {"data1": "value1", "data2": "value2"});

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Splash(),
    );
  }
}
