import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserloginController extends GetxController {
  //TODO: Implement UserloginController
  final Rx<TextEditingController> emailController = TextEditingController().obs;
  final Rx<bool> isCheck = false.obs;

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

  void increment() => count.value++;
}
