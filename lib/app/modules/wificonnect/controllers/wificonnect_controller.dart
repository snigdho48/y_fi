import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class WificonnectController extends GetxController {
  RxBool isConnected = false.obs;
  RxInt remainingTime = 60.obs; // Countdown time in seconds
  Timer? disconnectTimer;

  TextEditingController ssidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    requestPermissions();
  }

  /// Request necessary permissions for WiFi connection
  Future<void> requestPermissions() async {
    if (!(await Permission.location.isGranted)) {
      await Permission.location.request();
    }
    if (!(await Permission.locationWhenInUse.isGranted)) {
      await Permission.locationWhenInUse.request();
    }
  }

  /// Connect to a Wi-Fi network
  Future<void> connectToWiFi() async {
    String ssid = ssidController.text.trim();
    String password = passwordController.text.trim();

    if (ssid.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "SSID and Password cannot be empty");
      return;
    }

    var isWifiEnabled = await WiFiForIoTPlugin.isEnabled();
    if (!isWifiEnabled) {
      await WiFiForIoTPlugin.setEnabled(true);
    }

    // Check current connectivity status
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.wifi) {
      await WiFiForIoTPlugin.disconnect();
      await Future.delayed(const Duration(seconds: 2)); // Allow time to disconnect
    }

    bool connectionStarted = await WiFiForIoTPlugin.connect(
      ssid,
      password: password,
      security: NetworkSecurity.WPA,
      withInternet: true,
      joinOnce: true,
    );

    if (!connectionStarted) {
      Get.snackbar("Error", "Failed to start WiFi connection.");
      return;
    }

    await Future.delayed(const Duration(seconds: 5)); // Allow time to establish connection

    bool isConnectedNow = await WiFiForIoTPlugin.isConnected();
    if (isConnectedNow) {
      isConnected.value = true;
      startDisconnectTimer();
      Get.snackbar("Connected", "Connected to $ssid");
    } else {
      Get.snackbar("Error", "Could not establish WiFi connection.");
    }
  }

  /// Start countdown timer for disconnecting Wi-Fi
  void startDisconnectTimer() {
    disconnectTimer?.cancel();
    remainingTime.value = 60; // Reset timer to 60 seconds

    disconnectTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    disconnectTimer?.cancel();
    Get.snackbar("Disconnected", "WiFi disconnected.");
  }

  @override
  void onClose() {
    ssidController.dispose();
    passwordController.dispose();
    disconnectTimer?.cancel();
    super.onClose();
  }
}
