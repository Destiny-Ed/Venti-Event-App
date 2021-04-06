import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseClass {
  String uid;
  DatabaseClass(this.uid);

//Adding Event
  Future addEvents(
      {String eventName,
      String location,
      String description,
      bool done,
      String sendingTo,
      String date}) async {
    CollectionReference _events = FirebaseFirestore.instance.collection(uid);
    try {
      final body = {
        "eventName": eventName,
        "location": location,
        "description": description,
        "done" : done,
        "sendingTo": sendingTo,
        "date": date
      };
      await _events.add(body);

      return "Event added successfully";
    } catch (e) {
      return "Unable to add Event $e";
    }
  }

  //Update
  Future updateEvents(
      {String id,
      String eventName,
      String location,
      String description,
      bool done,
      String sendingTo,
      String date}) async {
    CollectionReference _events = FirebaseFirestore.instance.collection(uid);
    try {
      final body = {
        "eventName": eventName,
        "location": location,
        "description": description,
        "done" : done,
        "sendingTo": sendingTo,
        "date": date
      };
      await _events.doc(id).update(body);

      return "Event Updated successfully";
    } catch (e) {
      return "Unable to update Event $e";
    }
  }

  //Deleting Events
  Future deleteEvents({String id}) async {
    CollectionReference _events = FirebaseFirestore.instance.collection(uid);
    try {
      await _events.doc(id).delete();

      return "Event deleted successfully";
    } catch (e) {
      return "Unable to delete Event $e";
    }
  }
}
