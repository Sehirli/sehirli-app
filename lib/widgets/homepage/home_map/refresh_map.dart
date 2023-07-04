import 'package:flutter/material.dart';

class RefreshMap extends StatelessWidget {
  final Function() onPressed;

  const RefreshMap({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 10),
      child: FloatingActionButton(
        heroTag: "refresh_map",
        backgroundColor: Colors.black,
        onPressed: onPressed,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
