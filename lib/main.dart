import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:workmanager/workmanager.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:one_request/one_request.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    String ssid = inputData?['ssid'] ?? ''; 
    String password =
        inputData?['password'] ?? ''; 

    if (ssid.isNotEmpty && password.isNotEmpty) {
      await WiFiForIoTPlugin.connect(
        ssid,
        password: password,
        security: NetworkSecurity.WPA,
        withInternet: true,
        joinOnce: true,
      );
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  });
}

void main() async {
    oneRequest.loadingconfig();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Workmanager().initialize(
    callbackDispatcher, 
    isInDebugMode: false,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Portrait mode up
    DeviceOrientation.portraitDown, // Portrait mode down
  ]).then((_) {
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      builder: oneRequest.initLoading,

    ),
  );
  });
   WidgetsBinding.instance.addPostFrameCallback((_) {
    FlutterNativeSplash.remove();
  });
}
