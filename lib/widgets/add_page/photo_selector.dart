import 'package:flutter/material.dart';

import 'package:sehirli/widgets/custom_button.dart';

class PhotoSelector extends StatelessWidget {
  final Function() onPressed;

  const PhotoSelector({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        onPressed: onPressed,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        text: "Fotoğraf yükle",
      ),
    );
  }
}