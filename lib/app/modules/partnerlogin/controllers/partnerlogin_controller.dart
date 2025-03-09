import 'package:flutter/material.dart';
import 'package:free_y_fi/app/routes/app_pages.dart';
import 'package:get/get.dart';

class PartnerloginController extends GetxController {
  //TODO: Implement PartnerloginController

  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  bool validateEmail(String? value) {
    if (value == null) {
      return false;
    }
    if (value.isEmpty) {
      return false;
    }
    if (!GetUtils.isEmail(value)) {
      return false;
    }
    return true;
  }
  bool passwordValidation(String? value) {
    if (value == null) {
      return false;
    }
    if (value.isEmpty) {
      return false;
    }
    if (value.length < 6) {
      return false;
    }
    if (!GetUtils.hasMatch(value, r'[0-9]')) {
      return false;
    }
    return true;
  }

  void signup() {
   Get.toNamed(Routes.PARTNERSIGNUP);
  }
  void login() {
    if (validateEmail(emailController.value.text) &&
        passwordValidation(passwordController.value.text)) {
      Get.snackbar(
        "Success",
        "Login Successful",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black.withOpacity(0.5),
        colorText: Colors.green,
      );
    } else {
      Get.snackbar(
        "Error",
        "Please enter valid email and password",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black.withOpacity(0.5),
        colorText: Colors.red,
      );
    }
  }
}