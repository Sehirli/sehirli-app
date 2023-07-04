import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:sehirli/pages/home_pages/start_page.dart';
import 'package:sehirli/widgets/custom_button.dart';

class SignOutWidget extends StatelessWidget {
  const SignOutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.red,
              icon: const Icon(Icons.warning_amber, color: Colors.white),
              title: const Text(
                "Emin misin?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                )
              ),
              content: const Text(
                "İstediğin zaman geri giriş yapabilirsin. Hesap bilgilerin silinmez veya kaybolmaz.",
                style: TextStyle(color: Colors.white)
              ),
              actions: [
                CustomButton(
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  text: "Hayır",
                ),
                CustomButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();

                    if (context.mounted) {
                      Navigator.pop(context);

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const StartPage()
                        ),
                        (route) => false
                      );
                    }
                  },
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  text: "Evet",
                )
              ],
            );
          }
        );
      },
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      text: "Çıkış Yap"
    );
  }
}