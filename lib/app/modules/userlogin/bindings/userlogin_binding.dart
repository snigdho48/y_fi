import 'package:free_y_fi/app/modules/userlogin/controllers/facebooklogin.dart';
import 'package:free_y_fi/app/modules/userlogin/controllers/googlelogin.dart';
import 'package:get/get.dart';

import '../controllers/userlogin_controller.dart';

class UserloginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserloginController>(
      () => UserloginController(),
    );
    // Get.lazyPut<FacebookloginController>(
    //   () => FacebookloginController(),
    // );
    Get.lazyPut<GoogleloginController>(
      () => GoogleloginController(),
    );
  }
}
