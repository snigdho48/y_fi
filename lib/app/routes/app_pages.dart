import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/partnerlogin/bindings/partnerlogin_binding.dart';
import '../modules/partnerlogin/views/partnerlogin_view.dart';
import '../modules/partnersignup/bindings/partnersignup_binding.dart';
import '../modules/partnersignup/views/partnersignup_view.dart';
import '../modules/userlogin/bindings/userlogin_binding.dart';
import '../modules/userlogin/views/userlogin_view.dart';
import '../modules/wificonnect/bindings/wificonnect_binding.dart';
import '../modules/wificonnect/views/wificonnect_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.WIFICONNECT,
      page: () => const WificonnectView(),
      binding: WificonnectBinding(),
    ),
    GetPage(
      name: _Paths.USERLOGIN,
      page: () => const UserloginView(),
      binding: UserloginBinding(),
    ),
    GetPage(
      name: _Paths.PARTNERLOGIN,
      page: () => const PartnerloginView(),
      binding: PartnerloginBinding(),
    ),
    GetPage(
      name: _Paths.PARTNERSIGNUP,
      page: () => const PartnersignupView(),
      binding: PartnersignupBinding(),
    ),
  ];
}
