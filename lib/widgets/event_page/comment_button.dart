import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  final String eventId;

  const CommentButton({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.comment_rounded),
    );
  }
}
