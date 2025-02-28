import 'package:flutter/material.dart';
import 'package:free_y_fi/app/modules/userlogin/controllers/facebooklogin.dart';
import 'package:free_y_fi/app/modules/userlogin/controllers/googlelogin.dart';
import 'package:free_y_fi/app/modules/userlogin/controllers/phoneSignin.dart';
import 'package:free_y_fi/app/routes/app_pages.dart';
import 'package:get/get.dart';

class UserloginController extends GetxController {
  //TODO: Implement UserloginController
  final Rx<TextEditingController> emailController = TextEditingController().obs;
  final Rx<bool> isCheck = false.obs;
  final google = Get.put(GoogleloginController());
  // final fb = Get.put(FacebookloginController());
  final phone = Get.put(PhoneSigninController());

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void loginWithGoogle() {
    if (!isCheck.value) {
      Get.snackbar(
        "Error",
        "Please check the terms and conditions",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.5),
        colorText: Colors.red,
      );
      return;
    }
    google.signInGoogle();
  }

  void loginWithFacebook() {
    if (!isCheck.value) {
      Get.snackbar(
        "Error",
        "Please check the terms and conditions",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.5),
        colorText: Colors.red,
      );
      return;
    }
    // fb.signInFB();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void wificonnect() {
    Get.offAllNamed(Routes.WIFICONNECT);
  }

  void login() {
    final text = emailController.value.text;
    if (text.length == 11 && isValidPhoneNumber(text)) {
      phone.signInPhone('+88$text');
    }
  }

  bool isValidPhoneNumber(String? phoneNumber) {
    // Remove any non-digit characters (e.g., spaces, dashes)
    if (phoneNumber == null) {
      return false;
    }

    // Validate if the cleaned phone number has 11 digits and starts with '1'
    if (phoneNumber.length == 11 && phoneNumber.startsWith('01')) {
      return true;
    }
    return false;
  }
}
