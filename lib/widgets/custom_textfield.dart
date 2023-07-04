import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? fontFamily;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;
  final Widget? counter;

  const CustomTextField({
    super.key,
    this.hintText,
    this.controller,
    this.inputFormatters,
    this.initialValue,
    this.fontFamily,
    this.keyboardType,
    this.maxLength,
    this.maxLines,
    this.counter
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLines,
      style: TextStyle(
        fontFamily: fontFamily,
        color: Colors.white
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: hintText,
        counter: counter,
        hintStyle: TextStyle(
          fontFamily: fontFamily,
          color: Colors.white54
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(width: 2, color: Colors.white)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 2
          )
        ),
      ),
    );
  }
}