import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:venti/Screens/AuthScreen/login.dart';
import 'package:venti/utils.dart';

import 'MainPages/home_page.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  FirebaseAuth _auth;
  Future initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      print("Failed to initialize fire Store");
    }
  }

  @override
  void initState() {
    initializeFlutterFire().then((value) {
      setState(() {
        _auth = FirebaseAuth.instance;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_auth != null) {
      Future.delayed(const Duration(seconds: 3), () {
        if (_auth.currentUser == null) {
          PageRouter(context).openNextAndClearPrevious(page: LoginPage());
        } else {
          PageRouter(context).openNextAndClearPrevious(page: HomePage());
        }
      });
    } else {
      print("Error");
    }

    return Scaffold(
      body: Center(
        child: Text(
          'Venti',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
