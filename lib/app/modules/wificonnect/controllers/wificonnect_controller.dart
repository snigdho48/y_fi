import 'package:flutter/material.dart';
import 'package:free_y_fi/app/modules/background/workmanager_work.dart';
import 'package:get/get.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class WificonnectController extends GetxController {
  RxBool isConnected = false.obs;
  RxBool isConnecting = false.obs;
  RxInt remainingTime = 60.obs; 
  Timer? disconnectTimer;
  Timer? connectivityMonitor;
  RxBool isConnectedViaApp = false.obs;
  final qrCodeResult = ''.obs;
  var result = Rxn<Barcode>();
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  TextEditingController ssidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    requestPermissions();
    monitorWiFiStatus();
  }

  /// Requests required permissions
Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.bluetooth, // Required for Android 12+
      Permission.bluetoothScan, // Required for Android 12+
      Permission.bluetoothConnect, // Required for Android 12+
      Permission.camera,
      Permission.nearbyWifiDevices, // Required for Android 13+
    ].request();

    if (statuses[Permission.bluetooth] == PermissionStatus.permanentlyDenied ||
        statuses[Permission.bluetoothScan] ==
            PermissionStatus.permanentlyDenied ||
        statuses[Permission.bluetoothConnect] ==
            PermissionStatus.permanentlyDenied) {
      Get.snackbar(
          "Permissions Required", "Go to app settings to enable Bluetooth.");
      openAppSettings();
    }
  }


  /// Monitors WiFi status every 10 seconds
  void monitorWiFiStatus() {
    connectivityMonitor?.cancel();
    connectivityMonitor = Timer.periodic(Duration(seconds: 10), (timer) async {
      bool wifiStatus =
          await WiFiForIoTPlugin.isConnected() && isConnectedViaApp.value;
      isConnected.value = wifiStatus;
    });
  }

  /// Connects to a Wi-Fi network
  Future<void> connectToWiFi() async {
    String ssid = ssidController.text.trim();
    String password = passwordController.text.trim();

    if (ssid.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "SSID and Password cannot be empty");
      return;
    }

    isConnecting.value = true;

    bool isWifiEnabled = await WiFiForIoTPlugin.isEnabled();
    if (!isWifiEnabled) {
      await WiFiForIoTPlugin.setEnabled(true);
    }

  try{
      await WiFiForIoTPlugin.disconnect();  
      await Future.delayed(Duration(seconds: 5));
      print("WiFi disconnected");
    }catch(e){
      print("Error disconnecting WiFi: $e");
    }
    

    bool connectionStarted = await WiFiForIoTPlugin.connect(
      ssid,
      password: password,
      security: NetworkSecurity.WPA,
      withInternet: true,
      joinOnce: true,
    );

    if (connectionStarted) {
      scheduleWiFiConnectTask(ssid, password);
    } else {
      isConnecting.value = false;
      Get.snackbar("Error", "Failed to start WiFi connection.");
      return;
    }

    for (int i = 0; i < 10; i++) {
      await Future.delayed(Duration(seconds: 1));
      bool isConnectedNow = await WiFiForIoTPlugin.isConnected();
      if (isConnectedNow) {
        isConnected.value = true;
        isConnectedViaApp.value = true;
        isConnecting.value = false;
        startDisconnectTimer();
        Get.snackbar("Connected", "Connected to $ssid");
        return;
      }
    }

    isConnecting.value = false;
    isConnectedViaApp.value = false;
    Get.snackbar("Error", "Could not establish WiFi connection.");
  }

  /// Starts countdown timer for disconnecting WiFi
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

  /// Disconnects from Wi-Fi network
 Future<void> disconnectWiFi() async {
    try {
      if (await WiFiForIoTPlugin.isConnected()) {
        bool isDisconnected = await WiFiForIoTPlugin.disconnect();
        print("WiFi disconnected: $isDisconnected");

        if (!isDisconnected) {
          print("Trying alternative disconnect method...");
          await WiFiForIoTPlugin.disconnect();
        }
      }

      isConnected.value = false;
      isConnectedViaApp.value = false;
      disconnectTimer?.cancel();
      controller?.resumeCamera();
      Get.snackbar("Disconnected", "WiFi disconnected.");
    } catch (e) {
      print("Error disconnecting WiFi: $e");
      Get.snackbar("Error", "Could not disconnect from WiFi.");
    }
  }


  // QR Code Scanning Functions
  void startScanning() {
    qrCodeResult.value = '';
    controller?.resumeCamera();
  }

  void stopScanning() {
    controller?.pauseCamera();
  }

  void onQRViewCreated(QRViewController qrController) {
    controller = qrController;
    qrController.scannedDataStream.listen((scanData) {
      qrCodeResult.value = scanData.code ?? '';
      result.value = scanData;
      if (qrCodeResult.isNotEmpty) {

        ssidController.text = 'A Maze Venture';
        passwordController.text = 'Amaze@2024#';
        stopScanning();
      }
    });
  }

  @override
  void onClose() {
    ssidController.dispose();
    passwordController.dispose();
    disconnectTimer?.cancel();
    connectivityMonitor?.cancel();
    controller?.dispose();
    super.onClose();
  }
}
