import 'package:flutter/material.dart';
import 'package:free_y_fi/app/modules/background/workmanager_work.dart';
import 'package:get/get.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class WificonnectController extends GetxController {
  RxBool isConnected = false.obs;
  RxBool isConnecting = false.obs;
  RxInt remainingTime = 60.obs; // 10 minutes countdown (600 seconds)
  Timer? disconnectTimer;
  Timer? connectivityMonitor;
  RxBool isConnectedViaApp = false.obs;

  TextEditingController ssidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    requestPermissions();
    monitorWiFiStatus();
  }

  /// Request necessary permissions for WiFi connection
  Future<void> requestPermissions() async {
    if (!(await Permission.location.isGranted)) {
      await Permission.location.request();
    }
    if (!(await Permission.locationWhenInUse.isGranted)) {
      await Permission.locationWhenInUse.request();
    }
    if (!(await Permission.nearbyWifiDevices.isGranted)) {
      await Permission.nearbyWifiDevices.request();
    }
  }

  /// Monitors WiFi status every 10 seconds
  void monitorWiFiStatus() {
    connectivityMonitor?.cancel();
    connectivityMonitor = Timer.periodic(Duration(seconds: 10), (timer) async {
      bool wifiStatus = await WiFiForIoTPlugin.isConnected() && isConnectedViaApp.value;
      isConnected.value = wifiStatus;
    });
  }

Future<void> connectToWiFi() async {
    String ssid = ssidController.text.trim();
    String password = passwordController.text.trim();

    if (ssid.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "SSID and Password cannot be empty");
      return;
    }

    isConnecting.value = true;

    var isWifiEnabled = await WiFiForIoTPlugin.isEnabled();
    if (!isWifiEnabled) {
      await WiFiForIoTPlugin.setEnabled(true);
    }

    // Check current connectivity status
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.wifi) {
      await disconnectWiFi();
      await Future.delayed(Duration(seconds: 2)); // Allow time to disconnect
    }

    bool connectionStarted = await WiFiForIoTPlugin.connect(
      ssid,
      password: password,
      security: NetworkSecurity.WPA,
      withInternet: true,
      joinOnce: true,
    );

    // Schedule Wi-Fi connect task only if the connection started successfully
    if (connectionStarted) {
      scheduleWiFiConnectTask(ssid, password);
    } else {
      isConnecting.value = false;
      Get.snackbar("Error", "Failed to start WiFi connection.");
      return;
    }

    await Future.delayed(
        Duration(seconds: 5)); // Allow time to establish connection

    bool isConnectedNow = await WiFiForIoTPlugin.isConnected();
    if (isConnectedNow) {
      isConnected.value = true;
      isConnectedViaApp.value = true;
      isConnecting.value = false;
      startDisconnectTimer();
      Get.snackbar("Connected", "Connected to $ssid");
    } else {
      isConnecting.value = false;
      isConnectedViaApp.value = false;
      Get.snackbar("Error", "Could not establish WiFi connection.");
    }
  }
  /// Start countdown timer for disconnecting Wi-Fi
  void startDisconnectTimer() {
    disconnectTimer?.cancel();

    disconnectTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        disconnectWiFi();
        timer.cancel();
      }
    });
  }

  /// Disconnect from Wi-Fi network
  Future<void> disconnectWiFi() async {
    await WiFiForIoTPlugin.disconnect();
    isConnected.value = false;
    isConnectedViaApp.value = false;
    disconnectTimer?.cancel();
    Get.snackbar("Disconnected", "WiFi disconnected.");
  }

  @override
  void onClose() {
    ssidController.dispose();
    passwordController.dispose();
    disconnectTimer?.cancel();
    connectivityMonitor?.cancel();
    super.onClose();
  }
}
