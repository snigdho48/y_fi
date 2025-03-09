import 'package:free_y_fi/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final storage = GetStorage();
  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration(seconds: 5), () async {
      print("Stored name: ${storage.read('name')}");

      if (await storage.read('name') == null) {
        Get.offAllNamed(Routes.USERLOGIN);
      } else {
        if(storage.read('group_name') == 'user'){
          Get.offAllNamed(Routes.WIFICONNECT);
        }else{
          Get.offAllNamed(Routes.PARTNERDASHBOARD);
        }
      }
    });
  }
}
