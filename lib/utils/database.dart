import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sehirli/models/event.dart';

class Database {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<Event>> getAll(int timePassed) async {
    List<Event> events = [];

    QuerySnapshot<Map<String, dynamic>> data = await db.collection("events").where(
      "timestamp",
      isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(hours: timePassed))
    ).get();

    for (var docSnapshot in data.docs) {
      events.add(Event.fromJson(docSnapshot.data()));
    }

    return events;
  }

  Future<void> addEvent(Event event) async {
    try {
      await db.collection("events").doc(event.id).set(
        event.toJson()
      );
    } catch (_) {
      throw Exception();
    }
  }

  Future<void> reportEvent(String reportedBy, String eventId, String reason) async {
    try {
      await db.collection("reports").doc(eventId).set({
        "reportedBy": reportedBy,
        "reason": reason,
        "reportedAt": Timestamp.now()
      });
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<void> removeComment(String eventId, List commentsList) async {
    try {
      await db.collection("events").doc(eventId).update({
        "comments": commentsList
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addComment(String eventId, List commentsList) async {
    try {
      await db.collection("events").doc(eventId).update({
        "comments": commentsList
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List> getComments(String eventId) async {
    try {
      return (await db.collection("events").doc(eventId).get())["comments"];
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}