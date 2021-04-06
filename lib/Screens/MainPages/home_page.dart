import 'package:flutter/material.dart';
import 'package:venti/Providers/auth_provider.dart';

import 'package:venti/Screens/AuthScreen/login.dart';
import 'package:venti/Screens/MainPages/on_goinging.dart';

import 'package:venti/utils.dart';

import 'elasped.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple,
        title: Text("Venti"),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                AuthClass().signOut().then((value) {
                  PageRouter(context)
                      .openNextAndClearPrevious(page: LoginPage());
                });
              }),
        ],
      ),
      body: bottomWidgets[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavigationItem,
        currentIndex: currentIndex,
        selectedItemColor: Colors.purple,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
    );
  }

  final List<Widget> bottomWidgets = [OnGoing(), Elasped()];

  final List<BottomNavigationBarItem> bottomNavigationItem = [
    BottomNavigationBarItem(icon: Icon(Icons.timer), label: "OnGoing"),
    BottomNavigationBarItem(icon: Icon(Icons.timelapse), label: "Elasped"),
  ];
}
