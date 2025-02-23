import 'package:get/get.dart';

import '../controllers/userlogin_controller.dart';

class UserloginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserloginController>(
      () => UserloginController(),
    );
  }
}
