import 'package:flutter/material.dart';

class ErrorMap extends StatelessWidget {
  const ErrorMap({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          "Lütfen konum servislerini etkinleştirin!",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 18)
        )
      ),
    );
  }
}
