

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:free_y_fi/app/routes/app_pages.dart';
import 'package:free_y_fi/app/services/device_info.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PhoneSigninController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final storage = GetStorage();
  @override
  void onInit() {
    super.onInit();
  }
Future<UserCredential?> loginOrSignUp(String phoneNumber) async {
    final Completer<UserCredential?> completer = Completer();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);
          completer.complete(userCredential); // Return the result
        } catch (e) {
          completer.completeError(e);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Error: ${e.message}");
        completer.complete(null); // Return null if verification fails
      },
      codeSent: (String verificationId, int? resendToken) {
        print("OTP Sent but will be auto-retrieved");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("Auto-retrieval timeout");
      },
    );

    return completer.future; // Return the Future that completes later
  }
  Future<void> signInPhone(phone) async {
    final result = await loginOrSignUp(phone);
    if (result!= null && result.user != null) {
      if (storage.read('deviceid') == null) {
        final result = await getDeviceInfo();
        storage.write('deviceid', result['device_id']);
      }
      if (storage.read('name') == null) {
        await storage.write('email', result.user!.email);
        await storage.write('name', result.user!.displayName);
        await storage.write('phone', result.user!.phoneNumber);
        print("Stored name: ${storage.read('name')}");
      }

      Get.offAllNamed(Routes.WIFICONNECT);
      return;
    } else {
      Get.snackbar(
        "Error",
        "Google login failed",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.5),
        colorText: Colors.red,
      );
    }
  }
  @override
  void onReady() {
    super.onReady();
  }
}