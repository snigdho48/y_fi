import 'package:free_y_fi/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final storage = GetStorage();
  @override
  void onInit()async {
    super.onInit();

    await Future.delayed(Duration(seconds: 5), () async {
      print("Stored name: ${storage.read('name')}");

      if (await storage.read('name') == null) {
        Get.offAllNamed(Routes.USERLOGIN);
      } else {
          Get.offAllNamed(Routes.WIFICONNECT);
        
      }
    });
  }
}
