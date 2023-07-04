import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function() onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final String? text;
  final Widget? child;

  const CustomButton({
    super.key,
    this.text,
    this.child,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          )
        ),
      ),
      child: buildChild()
    );
  }

  Widget buildChild() {
    if (child != null) {
      return child!;
    } else {
      return Text(
        text!,
        style: TextStyle(
          fontSize: 19,
          color: foregroundColor,
        )
      );
    }
  }
}