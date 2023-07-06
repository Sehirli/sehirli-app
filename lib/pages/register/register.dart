import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sehirli/bloc/register/register_bloc.dart';
import 'package:sehirli/pages/register/sms_code_page.dart';
import 'package:sehirli/widgets/custom_button.dart';
import 'package:sehirli/utils/authentication.dart';
import 'package:sehirli/widgets/custom_textfield.dart';
import 'package:sehirli/injection_container.dart';
import 'package:url_launcher/url_launcher.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _controller = TextEditingController(text: "+90");

  final RegisterBloc bloc = sl<RegisterBloc>();

  bool checkedValue = false;

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
                const Text("Telefon Numaran", style: TextStyle(color: Colors.white, fontSize: 23), textAlign: TextAlign.center),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _controller,
                  hintText: "+90",
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    PhoneInputFormatter(allowEndlessPhone: false)
                  ],
                ),
                const SizedBox(height: 10),
                CheckboxListTile(
                  title: RichText(
                    text: TextSpan(
                      style: GoogleFonts.kanit(
                        fontSize: 15
                      ),
                      children: [
                        TextSpan(
                          text: "Kullanıcı Sözleşmesini",
                          style: const TextStyle(
                            color: Colors.blue
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            launchUrl(Uri.parse("https://sehirli.online/sozlesme"));
                          }
                        ),
                        const TextSpan(
                          text: " okudum ve kabul ediyorum.",
                        )
                      ]
                    ),
                  ),
                  value: checkedValue,
                  onChanged: (bool? value) {
                    setState(() {
                      checkedValue = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                ),
                const SizedBox(height: 10),
                CustomButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();

                    if (!checkedValue) {
                      Get.snackbar(
                        "Hata!",
                        "Şehirli'yi kullanabilmek için Kullanıcı Sözleşmesini kabul etmeniz gerekmektedir.",
                        colorText: Colors.white,
                        icon: const Icon(Icons.warning_amber, color: Colors.red)
                      );

                      return;
                    }

                    bloc.add(RegisterValidateNumber(value: _controller.text));
                  },
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  child: BlocBuilder(
                    bloc: bloc,
                    builder: (BuildContext context, state) {
                      if (state is RegisterCheckingPhone) {
                        return const Center(child: CupertinoActivityIndicator());
                      } else if (state is RegisterPhoneEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Get.snackbar(
                            "Hata!",
                            "Lütfen bir telefon numarası girin!",
                            colorText: Colors.white,
                            icon: const Icon(Icons.warning_amber, color: Colors.red)
                          );
                        });
                      } else if (state is RegisterPhoneInvalid) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Get.snackbar(
                            "Hata!",
                            "Lütfen geçerli bir numara girin!",
                            colorText: Colors.white,
                            icon: const Icon(Icons.warning_amber, color: Colors.red)
                          );
                        });
                      } else if (state is RegisterPhoneValid) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Authentication.instance.sendSMS(_controller.text);
                          Get.to(() => const SmsCodePage());
                        });
                      }

                      return const Text(
                        "Kayıt ol / Giriş Yap",
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                        )
                      );
                    }
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}