import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_count_down/date_count_down.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:venti/Providers/database_provider.dart';
import 'package:venti/Screens/MainPages/home_add_page.dart';
import 'package:venti/utils.dart';

class Elasped extends StatefulWidget {
  @override
  _ElaspedState createState() => _ElaspedState();
}

class _ElaspedState extends State<Elasped> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  String uid;

  Timer _timer;

  @override
  void initState() {
    //Initialize notification
    NotificationClass().initializeNotification();
    uid = _auth.currentUser.uid;

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference _reference = FirebaseFirestore.instance.collection(uid);

    return Scaffold(
      body: StreamBuilder(
        stream: _reference.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView(children: [
              ...snapshot.data.docs
                  .where((element) => element["done"] == true)
                  .map((DocumentSnapshot document) {
                final String eventName = document.data()["eventName"];
                final String date = document.data()["date"];
                final String desc = document.data()["description"];
                final String sendTo = document.data()["sendingTo"];
                final String location = document.data()["location"];
                final String id = document.id;

                final String dateCountDown = CountDown()
                    .timeLeft(DateTime.parse(date).toUtc(), "Event Done");

                //

                return GestureDetector(
                  onTap: () {
                    PageRouter(context).openNextPage(
                      page: AddEventPage(
                        "update",
                        id: id,
                        eventName: eventName,
                        desc: desc,
                        sendTo: sendTo,
                        location: location,
                        date: date,
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      // border: Border.all(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        dateCountDown,
                        style: TextStyle(fontSize: 25),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eventName,
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "To : $sendTo",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            location,
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            DatabaseClass(uid)
                                .deleteEvents(id: id)
                                .then((value) {
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(value),
                                ),
                              );
                            });
                          }),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(
                height: 80,
              )
            ]);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: Colors.purple,
      //   onPressed: () {
      //     PageRouter(context).openNextPage(page: AddEventPage("add"));
      //   },
      //   label: Row(
      //     children: [Icon(Icons.add), Text("Add Event")],
      //   ),
      // ),
    );
  }
}
