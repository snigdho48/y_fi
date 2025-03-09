import 'package:get/get.dart';

import '../controllers/partnersignup_controller.dart';

class PartnersignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartnersignupController>(
      () => PartnersignupController(),
    );
  }
}
