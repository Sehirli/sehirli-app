import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sehirli/pages/home_pages/home_page.dart';

import 'package:sehirli/pages/register/username_page.dart';
import 'package:sehirli/utils/authentication.dart';
import 'package:sehirli/widgets/custom_button.dart';
import 'package:sehirli/widgets/custom_textfield.dart';
import 'package:sehirli/pages/home_pages/start_page.dart';
import 'package:timer_count_down/timer_controller.dart';

import 'package:timer_count_down/timer_count_down.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SmsCodePage extends StatefulWidget {
  const SmsCodePage({super.key});

  @override
  State<SmsCodePage> createState() => _SmsCodePageState();
}

class _SmsCodePageState extends State<SmsCodePage> {
  final TextEditingController controller = TextEditingController();
  final CountdownController countdownController = CountdownController();

  Widget buttonChild = const Text(
    "İlerle",
    style: TextStyle(
      fontSize: 19,
      color: Colors.black,
    )
  );
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          padding: const EdgeInsets.all(15),
          color: Colors.black,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "SMS Kodu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23
                  ),
                  textAlign: TextAlign.center
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: "Kod",
                  controller: controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                  ],
                  counter: Countdown(
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
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const StartPage()
                        ),
                        (route) => false
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  onPressed: () async {
                    if (enabled) {
                      HapticFeedback.lightImpact();

                      countdownController.pause();

                      setState(() {
                        buttonChild = const Center(child: CupertinoActivityIndicator());
                        enabled = false;
                      });

                      bool verified = await Authentication.instance.verifyOTP(controller.text);
                      if (verified) {
                        if (FirebaseAuth.instance.currentUser!.displayName == null) {
                          if (context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => UsernamePage()
                              ),
                              (route) => false
                            );
                          }
                        } else {
                          Get.snackbar(
                            "Başarılı!",
                            "Giriş yaptınız.",
                            colorText: Colors.white,
                            icon: const Icon(Icons.verified_outlined, color: Colors.green),
                            shouldIconPulse: false
                          );
                          if (context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const HomePage()
                              ),
                              (route) => false
                            );
                          }
                        }
                      } else {
                        Get.snackbar(
                          "Hata!",
                          "Lütfen geliştiricilere bu hatayı bildirin.",
                          colorText: Colors.white,
                          icon: const Icon(Icons.warning_amber, color: Colors.red),
                        );

                        setState(() {
                          buttonChild = const Text(
                            "İlerle",
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.black,
                            )
                          );
                          enabled = true;
                        });
                      }
                    }
                  },
                  backgroundColor: enabled ? Colors.white : Colors.grey,
                  foregroundColor: Colors.black,
                  child: buttonChild,
                )
              ]
            ),
          ),
        )
      )
    );
  }
}