import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:sehirli/widgets/custom_button.dart';

class AppAbout extends StatelessWidget {
  const AppAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDialog(context),
      child: const Row(
        children: [
          Icon(Icons.location_city, color: Colors.white, size: 30),
          SizedBox(width: 5),
          Text(
            "Şehirli",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context) {
    HapticFeedback.lightImpact();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          icon: const Icon(Icons.location_city, color: Colors.white),
          title: const Text("Şehirli", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: const Text(
            "© Emir Sürmen 2023\nVersiyon 1.0.0",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: () {
                  Get.to(() => const LicensePage(
                    applicationIcon: Icon(Icons.location_city, color: Colors.white),
                    applicationVersion: "1.0.0",
                  ));
                },
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                text: "Lisansları Göster",
              ),
            )
          ],
        );
      }
    );
  }
}
