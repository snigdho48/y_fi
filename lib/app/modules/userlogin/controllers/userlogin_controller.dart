import 'package:flutter/material.dart';
import 'package:free_y_fi/app/modules/userlogin/controllers/facebooklogin.dart';
import 'package:free_y_fi/app/modules/userlogin/controllers/googlelogin.dart';
import 'package:free_y_fi/app/routes/app_pages.dart';
import 'package:get/get.dart';


class UserloginController extends GetxController {
  //TODO: Implement UserloginController
  final Rx<TextEditingController> emailController = TextEditingController().obs;
  final Rx<bool> isCheck = false.obs;
  final google = Get.put(GoogleloginController());
  final fb = Get.put(FacebookloginController());


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
 
  void wificonnect() {
    Get.offAllNamed(Routes.WIFICONNECT);
  }
}
