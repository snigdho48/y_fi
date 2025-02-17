import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:one_request/one_request.dart';
import 'package:geolocator/geolocator.dart';


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
  final jsonList = List<Map<String, String>>.empty().obs;
  
  TextEditingController ssidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    requestPermissions();
    monitorWiFiStatus();
    jsonList.value=[
      {
      'code': 'code1',
      "ssid": "A Maze Venture",
      "password": "Amaze@2024#"
    },
      {'code': 'code2', "ssid": "Snigdho_5G", "password": "22292646"},
      {'code': 'code3', "ssid": "Sayed family", "password": "yameen2012"},
      {'code': 'code4', "ssid": "AirStation", "password": "03070809"},
    ];
    
  }

  /// Requests required permissions
Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.bluetooth, // Required for Android 12+
      Permission.bluetoothScan, // Required for Android 12+
      Permission.bluetoothConnect, // Required for Android 12+
      Permission.camera,
      Permission.nearbyWifiDevices, // Required for Android 13+
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);

    if (!allGranted) {
      print("⚠️ Some permissions were denied: $statuses");
      return false;
    }

    print("✅ All required permissions granted.");
    return true;
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
Future<bool> isLocationEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(backgroundColor: Colors.black.withOpacity(0.5),"Location Required", "Please enable location services.",titleText:Text("Error",style: TextStyle(color: Colors.red,fontSize: 18),),messageText: Text("Please enable location services.",style: TextStyle(color: Colors.red),));
      return false;
    }
    return true;
  }

/// Connects to a Wi-Fi network
  Future<void> connectToWiFi() async {
    oneRequest.loading();

    // ✅ Request Permissions First
    bool hasPermissions = await requestPermissions();
    if (!hasPermissions) {
      Get.snackbar(backgroundColor: Colors.black.withOpacity(0.5),"Error", "Required permissions not granted.",titleText:Text("Error",style: TextStyle(color: Colors.red,fontSize: 18),),messageText: Text("Required permissions not granted.",style: TextStyle(color: Colors.red),));
      return;
    }

    // ✅ Ensure Location Services Are Enabled
    if (!await isLocationEnabled()) {
      oneRequest.dismissLoading();
      await Permission.location.request();
      Get.snackbar(backgroundColor: Colors.black.withOpacity(0.5),"Error", "Please enable location services.",titleText:Text("Error",style: TextStyle(color: Colors.red,fontSize: 18),),messageText: Text("Please enable location services.",style: TextStyle(color: Colors.red),));
      return;
    }

    // ✅ Scan for Available WiFi Networks
    List<WifiNetwork> networks = await WiFiForIoTPlugin.loadWifiList();
    String ssid = ssidController.text.trim();
    String password = passwordController.text.trim();

    if (ssid.isEmpty || password.isEmpty) {
      Get.snackbar(backgroundColor: Colors.black.withOpacity(0.5),"Error", "SSID and Password cannot be empty",titleText:Text("Error",style: TextStyle(color: Colors.red,fontSize: 18),),messageText: Text("SSID and Password cannot be empty",style: TextStyle(color: Colors.red),));
      return;
    }

    // ✅ Check if SSID exists in the scanned WiFi list
    bool ssidExists = networks.any((network) => network.ssid == ssid);
    if (!ssidExists) {
      Get.snackbar(backgroundColor: Colors.black.withOpacity(0.5),
          "Error", "WiFi '$ssid' not found in available networks.",titleText:Text("Error",style: TextStyle(color: Colors.red,fontSize: 18),),messageText: Text("WiFi '$ssid' not found in available networks.",style: TextStyle(color: Colors.red),));
      oneRequest.dismissLoading();
      return;
    }

    isConnecting.value = true;

    bool isWifiEnabled = await WiFiForIoTPlugin.isEnabled();
    if (!isWifiEnabled) {
      Get.snackbar(backgroundColor: Colors.black.withOpacity(0.5),"Error", "Please enable WiFi",titleText:Text("Error",style: TextStyle(color: Colors.red,fontSize: 18),),messageText: Text("Please enable WiFi",style: TextStyle(color: Colors.red),));
      await WiFiForIoTPlugin.setEnabled(true);
    }

    try {
      await WiFiForIoTPlugin.getSSID()
          .then((val) => WiFiForIoTPlugin.removeWifiNetwork(val!));
    } catch (e) {
      print("Error disconnecting WiFi: $e");
    }

    bool connectionStarted = await WiFiForIoTPlugin.connect(
      ssid,
      password: password,
      security: NetworkSecurity.WPA,
      withInternet: true,
    );

    if (connectionStarted) {
      print("✅ WiFi connection started");
    } else {
      isConnecting.value = false;
      Get.snackbar(backgroundColor: Colors.black.withOpacity(0.5),"Error", "Failed to start WiFi connection.",titleText:Text("Error",style: TextStyle(color: Colors.red,fontSize: 18),),messageText: Text("Failed to start WiFi connection.",style: TextStyle(color: Colors.red),));
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
        Get.snackbar(backgroundColor: Colors.black.withOpacity(0.5),"Connected", "Connected to $ssid",titleText: Text("Connected",style: TextStyle(color: Colors.green,fontSize:18),),messageText: Text("Connected to $ssid",style: TextStyle(color: Colors.green),));
        oneRequest.dismissLoading();
        return;
      } else {
        isConnecting.value = false;
        isConnectedViaApp.value = false;
        oneRequest.dismissLoading();
      }
    }
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
Future<void> disconnectFromWiFi() async {

    bool disconnected = await WiFiForIoTPlugin.disconnect();
          await Future.delayed(Duration(seconds: 2));
    if (disconnected) {
      print("✅ WiFi successfully disconnected");
    } else {
      print("❌ Failed to disconnect WiFi");
    }
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
      Get.snackbar(backgroundColor: Colors.black.withOpacity(0.5),"Disconnected", "WiFi disconnected.",titleText: Text("Disconnected",style: TextStyle(color: Colors.green,fontSize:18),),messageText: Text("WiFi disconnected.",style: TextStyle(color: Colors.green),));
    } catch (e) {
      print("Error disconnecting WiFi: $e");
      Get.snackbar(backgroundColor: Colors.black.withOpacity(0.5),"Error", "Could not disconnect from WiFi.",titleText:Text("Error",style: TextStyle(color: Colors.red,fontSize: 18),),messageText: Text("Could not disconnect from WiFi.",style: TextStyle(color: Colors.red),));
    }
  }
  Future<void> disconnectWiFi2() async {
    try {
      if (await WiFiForIoTPlugin.isConnected()) {
        bool isDisconnected = await WiFiForIoTPlugin.disconnect();
        print("WiFi disconnected: $isDisconnected");

        if (!isDisconnected) {
          print("Trying alternative disconnect method...");
          await WiFiForIoTPlugin.disconnect();
        }
      }
        qrCodeResult.value = '';
      

      isConnected.value = false;
      isConnectedViaApp.value = false;
      disconnectTimer?.cancel();
      controller?.resumeCamera();
      Get.snackbar(backgroundColor: Colors.black.withOpacity(0.5),"Disconnected", "WiFi disconnected.",titleText: Text("Disconnected",style: TextStyle(color: Colors.green,fontSize:18),),messageText: Text("WiFi disconnected.",style: TextStyle(color: Colors.green),));
    } catch (e) {
      print("Error disconnecting WiFi: $e");
      Get.snackbar(backgroundColor: Colors.black.withOpacity(0.5),"Error", "Could not disconnect from WiFi.",titleText:Text("Error",style: TextStyle(color: Colors.red,fontSize: 18),),messageText: Text("Could not disconnect from WiFi.",style: TextStyle(color: Colors.red),));
    }
  }

  // QR Code Scanning Functions
  void startScanning() {
    qrCodeResult.value = '';
    controller?.resumeCamera();
  }

  void stopScanning() {
    controller?.pauseCamera();
    controller?.stopCamera();
    
  }

  void onQRViewCreated(QRViewController qrController) {
    controller = qrController;
    qrController.scannedDataStream.listen((scanData) {
      qrCodeResult.value = scanData.code ?? '';
      result.value = scanData;
      if (qrCodeResult.isNotEmpty) {
        var data = jsonList.firstWhere(
          (element) => element['code'] == qrCodeResult.value,
          orElse: () => {'ssid': '', 'password': ''},
        );
        if (data.isNotEmpty) {
          ssidController.text = data['ssid']!;
          passwordController.text = data['password']!;
        }
        else{
          Get.snackbar(
              backgroundColor: Colors.black.withOpacity(0.7),
              "Error", "Invalid QR Code",titleText:Text("Error",style: TextStyle(color: Colors.red,fontSize: 18),),messageText: Text("Invalid QR Code",style: TextStyle(color: Colors.red),));
        }

   
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
