import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:sehirli/pages/home_topbar/account_page.dart';
import 'package:sehirli/pages/home_topbar/add_page.dart';
import 'package:sehirli/widgets/homepage/app_about.dart';

class HomeTopBar extends StatefulWidget {
  const HomeTopBar({super.key});

  @override
  State<HomeTopBar> createState() => _HomeTopBarState();
}

class _HomeTopBarState extends State<HomeTopBar> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser!.reload();

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AppAbout(),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Get.to(() => const AddPage());
                },
                icon: const Icon(
                  Icons.add_box_outlined,
                  color: Colors.white,
                  size: 29
                )
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AccountPage()
                    )
                  ).then((value) => setState(() {}));
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 1.5,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    foregroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
                    radius: 17,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}