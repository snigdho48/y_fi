import 'package:get/get.dart';

import '../controllers/partnerlogin_controller.dart';

class PartnerloginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartnerloginController>(
      () => PartnerloginController(),
    );
  }
}
