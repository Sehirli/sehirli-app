import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import 'package:sehirli/models/comment.dart';
import 'package:sehirli/utils/database.dart';
import 'package:sehirli/widgets/custom_button.dart';
import 'package:sehirli/widgets/custom_textfield.dart';

class CommentButton extends StatelessWidget {
  final String eventId;
  final List comments;
  final Function() callback;

  CommentButton({super.key, required this.eventId, required this.comments, required this.callback});

  final Database db = Database();

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Yorum ekle"),
              content: CustomTextField(controller: controller, hintText: "Ne söylemek istersin?"),
              actions: [
                CustomButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  text: "İptal",
                ),
                CustomButton(
                  onPressed: () async {
                    if (controller.text.isEmpty) {
                      Get.snackbar(
                        "Hata",
                        "Lütfen bir yorum yazın!",
                        colorText: Colors.white,
                        icon: const Icon(Icons.warning_amber, color: Colors.red)
                      );
                    }

                    List commentsList = comments;
                    User user = FirebaseAuth.instance.currentUser!;

                    commentsList.add(Comment(
                      commenterUid: user.uid,
                      commenterUsername: user.displayName!,
                      commentedAt: Timestamp.now(),
                      content: controller.text,
                      id: const Uuid().v1()
                    ).toJson());

                    await db.addComment(eventId, commentsList);

                    Get.snackbar(
                      "Başarılı!",
                      "Yorumun eklendi.",
                      colorText: Colors.white,
                      icon: const Icon(Icons.verified_outlined, color: Colors.green),
                      shouldIconPulse: false
                    );

                    if (context.mounted) {
                      Navigator.pop(context);
                      callback();
                    }
                  },
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  text: "Gönder",
                )
              ],
            );
          }
        );
      },
      icon: const Icon(Icons.comment_rounded),
    );
  }
}
