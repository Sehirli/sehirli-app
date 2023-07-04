import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:sehirli/widgets/account_page/change_pfp.dart';
import 'package:sehirli/widgets/account_page/change_username.dart';
import 'package:sehirli/widgets/account_page/sign_out_widget.dart';
import 'package:sehirli/widgets/custom_button.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Hesap", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white, size: 30),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ChangePfp(),
              CustomButton(
                onPressed: () => Get.to(() => ChangeUsername()),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                text: "Kullanıcı Adını Değiştir"
              ),
              const Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SignOutWidget(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
