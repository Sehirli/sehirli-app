import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sehirli/models/comment.dart';

class CommentsColumn extends StatelessWidget {
  final List comments;

  const CommentsColumn({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const SafeArea(
        child: Text("Şu anda herhangi bir yorum yok!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      );
    } else {
      return ListView.builder(
        itemCount: comments.length,
        itemBuilder: (BuildContext context, int index) {
          Comment comment = Comment.fromJson(comments[index]);

          return Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(comment.commenterUsername, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      buildDeleteButton(comment.commenterUid)
                    ],
                  ),
                  Text(DateFormat("dd-MM-yyyy hh:mm").format(comment.commentedAt.toDate())),
                  const Divider(thickness: 0.2),
                  Text(comment.content)
                ],
              ),
            ),
          );
        }
      );
    }
  }

  Widget buildDeleteButton(String commenterUid) {
    if (commenterUid == FirebaseAuth.instance.currentUser!.uid) {
      return GestureDetector(
        onTap: () {},
        child: const Icon(Icons.delete),
      );
    } else {
      return const SizedBox();
    }
  }
}
