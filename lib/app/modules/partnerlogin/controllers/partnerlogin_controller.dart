import 'package:flutter/material.dart';
import 'package:free_y_fi/app/data/url.dart';
import 'package:free_y_fi/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:one_request/one_request.dart';
import 'package:get_storage/get_storage.dart';

class PartnerloginController extends GetxController {
  //TODO: Implement PartnerloginController

  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final request = oneRequest();
  final storage = GetStorage();

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

  Future<void> login() async {
    if (validateEmail(emailController.value.text) &&
        passwordValidation(passwordController.value.text)) {
      try {
        final response = await request.send(
          url: '${baseurl}auth/partner/login/',
          method: RequestType.POST,
          resultOverlay: true,
          body: {
            "password": passwordController.value.text,
            "email": emailController.value.text,
          },
        );
        response.fold((data) {
          print('Data: $data');
          storage.write('token', data['token']);
          storage.write('email', data['email']);
          storage.write('name', data['username']);
          storage.write('group_name', data['group_name']);

          Get.snackbar(
            "Success",
            "Welcome ${data['username']}",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.black.withOpacity(0.5),
            colorText: Colors.green,
            duration: Duration(seconds: 5),
          );
          Get.offAllNamed(Routes.PARTNERDASHBOARD);
        }, (er) {
          Get.snackbar("Error", "Error: ${er}",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.black.withOpacity(0.5),
              colorText: Colors.red,
              duration: Duration(seconds: 5));
        });
      } catch (e) {
        Get.snackbar(
          "Error",
          "Please enter valid email and password",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.black.withOpacity(0.5),
          colorText: Colors.red,
          duration: Duration(seconds: 5),
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Please enter valid email and password",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black.withOpacity(0.5),
        colorText: Colors.red,
        duration: Duration(seconds: 5),
      );
    }
  }
}
