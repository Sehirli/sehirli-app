import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String addedBy;
  final String title;
  final String description;
  final Timestamp timestamp;
  final GeoPoint geoPoint;
  final String eventType;
  final List comments;

  Event({
    required this.id,
    required this.addedBy,
    required this.title,
    required this.timestamp,
    required this.description,
    required this.geoPoint,
    required this.eventType,
    required this.comments
  });

  factory Event.fromJson(Map<String, dynamic> data) {
    return Event(
      id: data["id"],
      addedBy: data["addedBy"],
      title: data["title"],
      description: data["description"],
      timestamp: data["timestamp"],
      geoPoint: data["geoPoint"],
      eventType: data["eventType"],
      comments: data["comments"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "addedBy": addedBy,
      "title": title,
      "description": description,
      "timestamp": timestamp,
      "geoPoint": geoPoint,
      "eventType": eventType,
      "comments": comments
    };
  }
}
