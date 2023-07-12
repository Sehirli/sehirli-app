import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class Authentication extends GetxController {
  static Authentication get instance => Get.find();
  var verificationId = "".obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  void sendSMS(String phoneNumber) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      timeout: const Duration(seconds: 120),
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == "invalid-phone-number") {
          throw Exception("Invalid phone number.");
        } else if (e.code == "invalid-credential") {
          throw Exception("Invalid SMS code.");
        }

        if (kDebugMode) {
          print(e.code);
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        this.verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<bool> verifyOTP(String smsCode) async {
    try {
      UserCredential credential = await auth.signInWithCredential(PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: smsCode
      ));

      return credential.user != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> reAuthenticate(String smsCode) async {
    try {
      UserCredential credential = await auth.currentUser!.reauthenticateWithCredential(PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: smsCode
      ));

      return credential.user != null;
    } catch (e) {
      return false;
    }
  }
}