import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

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
  
  ];
}
