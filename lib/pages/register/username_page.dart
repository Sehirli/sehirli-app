import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:sehirli/bloc/username/username_bloc.dart';
import 'package:sehirli/pages/home_pages/home_page.dart';
import 'package:sehirli/widgets/custom_button.dart';
import 'package:sehirli/widgets/custom_textfield.dart';
import 'package:sehirli/injection_container.dart';

class UsernamePage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final UsernameBloc bloc = sl<UsernameBloc>();

  final Widget initialChild = const Text(
    "İlerle",
    style: TextStyle(
      fontSize: 19,
      color: Colors.black,
    )
  );

  UsernamePage({super.key});

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
                  "Kullanıcı adı",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23
                  ),
                  textAlign: TextAlign.center
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: "Bir kullanıcı adı girin",
                  controller: controller,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    bloc.add(
                      SetUsernameOfUser(
                        username: controller.text
                      )
                    );
                  },
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  child: BlocBuilder(
                    bloc: bloc,
                    builder: (BuildContext context, UsernameState state) {
                      if (state is UsernameLoading) {
                        return const Center(
                          child: CupertinoActivityIndicator(
                            color: Colors.black
                          )
                        );
                      } else if (state is UsernameSetError) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Get.snackbar(
                            "Hata",
                            state.message,
                            colorText: Colors.white,
                            icon: const Icon(Icons.warning_amber, color: Colors.red)
                          );
                        });

                        return initialChild;
                      } else if (state is UsernameSetSuccess) {
                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          Get.snackbar(
                            "Başarılı!",
                            "O zaman başlayalım!",
                            colorText: Colors.white,
                            icon: const Icon(Icons.verified_outlined, color: Colors.green)
                          );

                          await FirebaseAuth.instance.currentUser!.updatePhotoURL("https://i.imgur.com/YY9AfMh.png");
                          Get.to(() => const HomePage());
                        });

                        return initialChild;
                      }

                      return initialChild;
                    }
                  ),
                )
              ]
            )
          ),
        ),
      ),
    );
  }
}