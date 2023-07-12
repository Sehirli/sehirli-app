import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:get/get.dart';

import 'package:sehirli/utils/authentication.dart';
import 'package:sehirli/widgets/custom_button.dart';
import 'package:sehirli/pages/home_pages/start_page.dart';
import 'package:sehirli/widgets/custom_textfield.dart';

class DeleteAccountWidget extends StatelessWidget {
  DeleteAccountWidget({super.key});

  final TextEditingController controller = TextEditingController();

  final CountdownController countdownController = CountdownController();

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () {
        HapticFeedback.lightImpact();

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
                "Bu işlem geri alınamaz. Tüm hesap bilgilerin sıfırlanacaktır ve silinecektir.",
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
                    Navigator.pop(context);

                    Authentication.instance.sendSMS(FirebaseAuth.instance.currentUser!.phoneNumber!);

                    smsCodeDialog(context);
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
      text: "Hesabı Sil",
    );
  }

  Widget countdown(BuildContext context) {
    return Countdown(
      seconds: 120,
      controller: countdownController,
      build: (_, double time) {
        countdownController.start();

        return Text(
          time.toInt().toString(),
          style: const TextStyle(
              color: Colors.white
          ),
        );
      },
      onFinished: () {
        Get.snackbar(
          "Süreniz doldu!",
          "SMS kodunu girmek için süreniz doldu. Lütfen tekrar deneyiniz.",
          colorText: Colors.white,
          icon: const Icon(Icons.timer_outlined, color: Colors.red),
          shouldIconPulse: false,
          duration: const Duration(seconds: 5)
        );
        Navigator.pop(context);
      },
    );
  }

  void smsCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Widget child =  const Text("Tamam", style: TextStyle(
          fontSize: 19,
          color: Colors.red,
        ));
        bool enabled = true;

        return AlertDialog(
          backgroundColor: Colors.red,
          title: const Text("SMS kodu"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Sana doğrulama için bir SMS kodu gönderdik."),
              CustomTextField(
                  controller: controller,
                  maxLength: 6,
                  counter: countdown(context)
              ),
            ],
          ),
          actions: [
            CustomButton(
              onPressed: () {
                HapticFeedback.lightImpact();

                countdownController.pause();
                Navigator.pop(context);
              },
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
              text: "Vazgeç",
            ),
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return CustomButton(
                  onPressed: () async {
                    if (enabled) {
                      setState(() {
                        child = const CupertinoActivityIndicator();
                        enabled = false;
                      });

                      User user = FirebaseAuth.instance.currentUser!;

                      bool verified = await Authentication.instance.reAuthenticate(controller.text);

                      if (verified) {
                        if (context.mounted) {
                          Navigator.pop(context);

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Container(
                                  color: Colors.black.withOpacity(.5),
                                  child: const Center(child: CircularProgressIndicator())
                              );
                            },
                          );

                          Navigator.pop(context);
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const StartPage()
                            ),
                            (route) => false
                          );
                        }

                        if (user.photoURL! != "https://i.imgur.com/YY9AfMh.png") {
                          await FirebaseStorage.instance.refFromURL(user.photoURL!).delete();
                        }

                        await user.delete();
                      } else {
                        Get.snackbar(
                          "Hata!",
                          "Lütfen geçerli bir SMS kodu girin!",
                          colorText: Colors.white,
                          icon: const Icon(Icons.warning_amber, color: Colors.red),
                        );

                        setState(() {
                          child = const Text("Tamam", style: TextStyle(
                            fontSize: 19,
                            color: Colors.red,
                          ));
                          enabled = true;
                        });
                      }
                    }
                  },
                  backgroundColor: enabled ? Colors.white : Colors.grey,
                  foregroundColor: Colors.red,
                  child: child,
                );
              },
            ),
          ],
        );
      }
    );
  }
}
