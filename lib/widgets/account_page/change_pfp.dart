import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import 'package:sehirli/widgets/custom_button.dart';
import 'package:sehirli/utils/image_selector.dart';

class ChangePfp extends StatelessWidget {
  final ImageSelector imageSelector = ImageSelector();
  final storageRef = FirebaseStorage.instance.ref();

  ChangePfp({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () async {
        try {
          if (context.mounted) {
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
          }

          XFile? image = await imageSelector.pick();
          User user = FirebaseAuth.instance.currentUser!;

          if (image != null) {
            await FirebaseStorage.instance.refFromURL(user.photoURL!).delete();

            Reference imageRef = storageRef.child("users/${user.uid}/${image.name}");

            await imageRef.putFile(File(image.path));

            user.updatePhotoURL(await imageRef.getDownloadURL());

            if (context.mounted) {
              Navigator.pop(context);
            }

            Get.snackbar(
              "Başarılı!",
              "Profil fotoğrafınız başarıyla değiştirildi.",
              colorText: Colors.white,
              icon: const Icon(Icons.verified_outlined, color: Colors.green),
              shouldIconPulse: false
            );
          } else {
            if (context.mounted) {
              Navigator.pop(context);
            }
            return;
          }
        } catch (exception) {
          Get.snackbar(
            "Hata!",
            "Fotoğraf yüklenemedi!",
            colorText: Colors.white,
            icon: const Icon(Icons.warning_amber, color: Colors.red),
            shouldIconPulse: false
          );

          debugPrint(exception.toString());

          Navigator.pop(context);
          return;
        }
      },
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      text: "Profil Fotoğrafını Değiştir",
    );
  }
}
