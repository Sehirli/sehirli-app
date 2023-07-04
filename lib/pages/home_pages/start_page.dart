import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:sehirli/pages/register/register.dart';
import 'package:sehirli/widgets/custom_button.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Merhaba",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Colors.white,
                  )
                ),
              ),
              const Text(
                "Şehirli'ye hoş geldin. Şehrinde olup bitenden anında haberdar olmaya hazır mısın?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                )
              ),
              CustomButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Get.to(() => Register());
                },
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                text: "Başlayalım",
              )
            ],
          ),
        ),
      ),
    );
  }
}
