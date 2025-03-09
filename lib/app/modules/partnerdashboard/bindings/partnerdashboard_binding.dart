import 'package:get/get.dart';

import '../controllers/partnerdashboard_controller.dart';

class PartnerdashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartnerdashboardController>(
      () => PartnerdashboardController(),
    );
  }
}
