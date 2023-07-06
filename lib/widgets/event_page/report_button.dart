import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:sehirli/utils/database.dart';
import 'package:sehirli/widgets/custom_button.dart';
import 'package:sehirli/widgets/custom_textfield.dart';

class ReportButton extends StatelessWidget {
  final Database database = Database();
  final TextEditingController controller = TextEditingController();

  final String eventId;

  ReportButton({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Rapor et"),
              content: CustomTextField(controller: controller, hintText: "Ne seni rahatsız etti?"),
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
                    await database.reportEvent(
                      FirebaseAuth.instance.currentUser!.phoneNumber!,
                      eventId,
                      controller.text
                    );

                    Get.snackbar(
                      "Başarılı!",
                      "Raporun için teşekkür ederiz! En kısa zamanda olaya el atacağız.",
                      colorText: Colors.white,
                      icon: const Icon(Icons.verified_outlined, color: Colors.green),
                      shouldIconPulse: false
                    );

                    if (context.mounted) {
                      Navigator.pop(context);
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
      icon: const Icon(Icons.flag, color: Colors.white)
    );
  }
}
