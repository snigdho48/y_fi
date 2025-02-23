import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:free_y_fi/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'dart:async';

class HomeController extends GetxController {
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
    super.onInit();

    Future.delayed(Duration(seconds: 5), () {
      Get.offAllNamed(Routes.USERLOGIN);
    });
  }


 
}


