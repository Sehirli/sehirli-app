import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:sehirli/widgets/custom_textfield.dart';
import 'package:sehirli/bloc/username/username_bloc.dart';
import 'package:sehirli/widgets/custom_button.dart';
import 'package:sehirli/injection_container.dart';

class ChangeUsername extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final UsernameBloc bloc = sl<UsernameBloc>();

  ChangeUsername({super.key});

  final Widget initialChild = const Text(
    "Tamam",
    style: TextStyle(
      fontSize: 19,
      color: Colors.black,
    )
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Kullanıcı Adını Değiştir"),
        backgroundColor: Colors.black,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: Container(
          padding: const EdgeInsets.all(10),
          height: double.infinity,
          child: Column(
            children: [
              CustomTextField(
                controller: controller,
                hintText: "Bir şeyler yazın...",
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
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
                            "Kullanıcı adınız başarıyla güncellendi!",
                            colorText: Colors.white,
                            icon: const Icon(Icons.verified_outlined, color: Colors.green)
                          );

                          Navigator.pop(context);
                        });

                        return initialChild;
                      }

                      return initialChild;
                    }
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
