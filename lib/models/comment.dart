import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String commenterUid;
  final String commenterUsername;
  final Timestamp commentedAt;
  final String content;

  Comment({
    required this.id,
    required this.commenterUid,
    required this.commenterUsername,
    required this.commentedAt,
    required this.content
  });

  factory Comment.fromJson(Map<String, dynamic> data) {
    return Comment(
      id: data["id"],
      commenterUid: data["commenterUid"],
      commenterUsername: data["commenterUsername"],
      commentedAt: data["commentedAt"],
      content: data["content"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "commenterUid": commenterUid,
      "commenterUsername": commenterUsername,
      "commentedAt": commentedAt,
      "content": content
    };
  }
}
