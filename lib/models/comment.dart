import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String commenterUid;
  final String commenterUsername;
  final Timestamp commentedAt;
  final String content;

  Comment({
    required this.commenterUid,
    required this.commenterUsername,
    required this.commentedAt,
    required this.content
  });

  factory Comment.fromJson(Map<String, dynamic> data) {
    return Comment(
      commenterUid: data["commenterUid"],
      commenterUsername: data["commenterUsername"],
      commentedAt: data["commentedAt"],
      content: data["content"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "commenterUid": commenterUid,
      "commenterUsername": commenterUsername,
      "commentedAt": commentedAt,
      "content": content
    };
  }
}
