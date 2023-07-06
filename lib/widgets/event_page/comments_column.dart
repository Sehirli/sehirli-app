import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import 'package:sehirli/models/comment.dart';
import 'package:sehirli/models/event.dart';
import 'package:sehirli/utils/database.dart';

class CommentsColumn extends StatefulWidget {
  final Event event;
  final List comments;
  final Function() callback;

  const CommentsColumn({super.key, required this.event, required this.callback, required this.comments});

  @override
  State<CommentsColumn> createState() => _CommentsColumnState();
}

class _CommentsColumnState extends State<CommentsColumn> {
  final Database db = Database();
  List? commentsList;

  @override
  Widget build(BuildContext context) {
    commentsList = List.from(widget.comments.reversed);

    if (commentsList!.isEmpty) {
      return const Text("Şu anda herhangi bir yorum yok!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
    } else {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: commentsList!.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          Comment comment = Comment.fromJson(commentsList![index]);

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
                      buildDeleteButton(comment)
                    ],
                  ),
                  Text(DateFormat("dd-MM-yyyy HH:mm").format(comment.commentedAt.toDate())),
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

  Widget buildDeleteButton(Comment comment) {
    if (comment.commenterUid == FirebaseAuth.instance.currentUser!.uid) {
      return GestureDetector(
        onTap: () {
          try {
            commentsList!.removeWhere((currentComment) => currentComment["id"] == comment.id);
            db.removeComment(widget.event.id, commentsList!);
            widget.callback();

            Get.snackbar(
              "Başarılı!",
              "Yorumun silindi.",
              colorText: Colors.white,
              icon: const Icon(Icons.verified_outlined, color: Colors.green),
              shouldIconPulse: false
            );

          } catch (e) {
            debugPrint(e.toString());
            Get.snackbar(
              "Hata",
              "Yorum silinemedi!",
              colorText: Colors.white,
              icon: const Icon(Icons.warning_amber, color: Colors.red)
            );
          }
        },
        child: const Icon(Icons.delete),
      );
    } else {
      return const SizedBox();
    }
  }
}
