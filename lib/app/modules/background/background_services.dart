import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:wifi_iot/wifi_iot.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

void onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
  }

  Timer.periodic(const Duration(minutes: 1), (timer) async {
    bool isConnected = await WiFiForIoTPlugin.isConnected();
    if (!isConnected) {
      await WiFiForIoTPlugin.connect(
        "Your_SSID",
        password: "Your_Password",
        security: NetworkSecurity.WPA,
        withInternet: true,
        joinOnce: true,
      );
    }
  });
}

bool onIosBackground(ServiceInstance service) {
  Timer.periodic(const Duration(minutes: 1), (timer) async {
    bool isConnected = await WiFiForIoTPlugin.isConnected();
    if (!isConnected) {
      await WiFiForIoTPlugin.connect(
        "Your_SSID",
        password: "Your_Password",
        security: NetworkSecurity.WPA,
        withInternet: true,
        joinOnce: true,
      );
    }
  });
  return true;
}
