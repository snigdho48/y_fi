import 'package:get/get.dart';

import '../controllers/wificonnect_controller.dart';

class WificonnectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WificonnectController>(
      () => WificonnectController(),
    );
  }
}
