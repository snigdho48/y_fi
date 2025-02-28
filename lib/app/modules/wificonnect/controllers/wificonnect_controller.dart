import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:free_y_fi/app/data/url.dart';
import 'package:free_y_fi/app/modules/notifications/notifications.dart';
import 'package:free_y_fi/app/services/device_info.dart';
import 'package:get/get.dart';
import 'package:one_request/one_request.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';


class WificonnectController extends GetxController {
  RxBool isConnected = false.obs;
  final request = oneRequest();
  RxBool isConnecting = false.obs;
  RxInt remainingTime = 0.obs; 
  final disconnectTime = 30*60;
  Timer? disconnectTimer;
  RxBool isRun = false.obs;
  Timer? loadingtimer;
  RxBool connectFirstTime = true.obs;
  Timer? connectivityMonitor;
  RxBool isConnectedViaApp = false.obs;
  final ip = ''.obs;
  final qrCodeResult = ''.obs;
  var result = Rxn<Barcode>();
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final jsonList = List<Map<String, String>>.empty().obs;
  final localStorage = GetStorage();
  final isLoading = false.obs;
  final loadingCount = 0.obs;
  final venu = ''.obs;
  final venuuuid = 0.obs;
  final isFirstTime = true.obs;
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
      'venu':'Office',
      "ssid": "A Maze Venture",
      "password": "Amaze@2024#"
    },
      {'code': 'code2','venu':'MY Home', "ssid": "Snigdho_5G", "password": "22292646"},
      {'code': 'code3','venu':"Vai's Home",  "ssid": "Sayed family", "password": "yameen2012"},
      {'code': 'code4','venu':"Vai's Office",
       "ssid": "AirStation", "password": "03070809"},
    ];
    
  }

  /// Requests required permissions
Future<bool> requestPermissions() async {
    List<Permission> requiredPermissions = [
      Permission.location,
      Permission.camera,
      Permission.backgroundRefresh,
      Permission.nearbyWifiDevices, // Required for Android 13+
      Permission.notification, // For notification permissions (Android 13+)
    ];

    Map<Permission, PermissionStatus> statuses =
        await requiredPermissions.request();

    if(statuses[Permission.location] == PermissionStatus.denied){
      Get.snackbar(
        "Permissions Required",
        "Please grant permission ${Permission.location.toString().split('.').last}.",
        backgroundColor: Colors.black.withOpacity(0.5),
        titleText: Text(
          "Error",
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
        messageText: Text(
          "Please grant ${Permission.location.toString().split('.').last} required permissions.",
          style: TextStyle(color: Colors.red),
        ),
      );
      print("❌ Location permission denied");
      return false;
    }
    if(statuses[Permission.camera] == PermissionStatus.denied){
      Get.snackbar(
        "Permissions Required",
        "Please grant permission ${Permission.camera.toString().split('.').last}.",
        backgroundColor: Colors.black.withOpacity(0.5),
        titleText: Text(
          "Error",
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
        messageText: Text(
          "Please grant ${Permission.camera.toString().split('.').last} required permissions.",
          style: TextStyle(color: Colors.red),
        ),
      );
      print("❌ Camera permission denied");
            return false;

    }

    if(statuses[Permission.nearbyWifiDevices] == PermissionStatus.denied){
      Get.snackbar(
        "Permissions Required",
        "Please grant permission ${Permission.nearbyWifiDevices.toString().split('.').last}.",
        backgroundColor: Colors.black.withOpacity(0.5),
        titleText: Text(
          "Error",
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
        messageText: Text(
          "Please grant ${Permission.nearbyWifiDevices.toString().split('.').last} required permissions.",
          style: TextStyle(color: Colors.red),
        ),
      );
      print("❌ Nearby WiFi Devices permission denied");
            return false;

    }
    if(statuses[Permission.notification] == PermissionStatus.denied){
      Get.snackbar(
        "Permissions Required",
        "Please grant permission ${Permission.notification.toString().split('.').last}.",
        backgroundColor: Colors.black.withOpacity(0.5),
        titleText: Text(
          "Error",
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
        messageText: Text(
          "Please grant ${Permission.notification.toString().split('.').last} required permissions.",
          style: TextStyle(color: Colors.red),
        ),
      );
      print("❌ Notification permission denied");
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

 isConnected.value = false;
remainingTime.value = disconnectTime;
    // ✅ Ensure Location Services Are Enabled
    if (!await isLocationEnabled()) {
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
      return;
    }

    isConnecting.value = true;

    bool isWifiEnabled = await WiFiForIoTPlugin.isEnabled();
    if (!isWifiEnabled) {
      Get.snackbar(backgroundColor: Colors.black.withOpacity(0.5),"Error", "Please enable WiFi",titleText:Text("Error",style: TextStyle(color: Colors.red,fontSize: 18),),messageText: Text("Please enable WiFi",style: TextStyle(color: Colors.red),));
      await WiFiForIoTPlugin.setEnabled(true);
    }
   print(ssid);
   print(password);

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
    if (!connectionStarted){
      
      await Future.delayed(Duration(seconds:2),()async{
        connectionStarted = await WiFiForIoTPlugin.connect(
        ssid,
        password: password,
        security: NetworkSecurity.WPA,
        withInternet: true,
        );
      });
    }
    if (connectionStarted) {
      print("✅ WiFi connection started");
        localStorage.write('venu',venu.value );
        localStorage.write('ssid', ssid);
        localStorage.write('password', password);

        isConnectedViaApp.value = true;
        isConnecting.value = false;

        startDisconnectTimer();
        Get.snackbar(
            backgroundColor: Colors.black.withOpacity(0.5),
            "Connected",
            "Connected to $ssid",
            titleText: Text(
              "Connected",
              style: TextStyle(color: Colors.green, fontSize: 18),
            ),
            messageText: Text(
              "Connected to $ssid",
              style: TextStyle(color: Colors.green),
            ));
        
        try {
          showNotification(
              "Wi-Fi Connected", "You have been connected to $ssid");
        } catch (e) {
          print(e);
        }
     

    } else {
      isConnecting.value = false;
      isConnected.value = false;
      Get.snackbar(backgroundColor: Colors.black.withOpacity(0.5),"Error", "Failed to start WiFi connection.",titleText:Text("Error",style: TextStyle(color: Colors.red,fontSize: 18),),messageText: Text("Failed to start WiFi connection.",style: TextStyle(color: Colors.red),));
      return;
    }
  }


  /// Starts countdown timer for disconnecting WiFi
  void startDisconnectTimer() async {
    disconnectTimer?.cancel();
    getDeviceInfo().then((value) {
      if(connectFirstTime.value){
        ip.value = value['ip'] ?? '';
        connectFirstTime.value = false;
      }
       request.send(
          url:
              "${baseurl}data/collect/",
          method: RequestType.POST,
          resultOverlay: false,
          body: {
            "device_id": value['device_id'],
            "device_name": value['device_name'],
            "device_os": value['device_os'],
            "device_brand": value['device_brand'],
            "partner": venuuuid.value,
            'ip':ip.value
          },
          loader: false,
          header: {
            'Authorization': 'Bearer ${localStorage.read('token')}'
          }).then((value) => value.fold((data) {
            print(data);
          }, (er) {
            print(er.toString());
          }));
    });
   
    

    isConnected.value = true;
    disconnectTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        disconnectWiFi();
        timer.cancel();
        isConnected.value = false;
        isRun.value = true;
      }
    });
  }
    void startloadingTimer() async{
      if(localStorage.read('isFirstTime') == null){
        localStorage.write('isFirstTime', false);
        isFirstTime.value = false;
        await WiFiForIoTPlugin.connect(
        ssidController.text.trim(),
        password: passwordController.text.trim(),
        security: NetworkSecurity.WPA,
        withInternet: true,
      );

      }else{
        isFirstTime.value = localStorage.read('isFirstTime');
      }
      
      isRun.value = false;
    loadingtimer?.cancel();
    loadingCount.value = 20;
    isLoading.value = true;

    loadingtimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (loadingCount.value > 0) {
        loadingCount.value--;
      } else {
        timer.cancel();
        isLoading.value = false;
        connectToWiFi();
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
        showNotification("Wi-Fi Disconnected",
          "You have been disconnected from the Wi-Fi network.");

      remainingTime.value = 0;

      isConnecting.value = false;
      isConnectedViaApp.value = false;
      isConnected.value = false;  
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
        
        remainingTime.value = 0;
        venu.value = '';
        venuuuid.value = 0;
        ssidController.text = '';
        passwordController.text = '';
        isConnecting.value = false;
        isConnectedViaApp.value = false;
        connectFirstTime.value = true;
        isConnected.value = false;
        disconnectTimer?.cancel();
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
    qrController.scannedDataStream.listen((scanData) async {
   if (!(scanData.code?.contains('?code=') ?? false)) {
        return;
      }
      final finaldata = scanData.code?.split('?code=').last ?? '';
      qrCodeResult.value = finaldata;
      if(qrCodeResult.value.isEmpty){
        return;
      }
      print("QR Code Result: ${scanData.code?.split('?code=')}");
      result.value = scanData;
      if (qrCodeResult.isNotEmpty) {
        stopScanning();
        print("QR Code Result: ${qrCodeResult.value}");
        var response = await request.send(url:'${baseurl}venue/data/' , method: RequestType.POST, body: {
          'code': qrCodeResult.value
        },
        resultOverlay: false,
        header: {
          'Authorization': 'Bearer ${localStorage.read('token')}'
        });
        

        response.fold(
          (data) {
            print(data);
          ssidController.text = data['ssid']!;
          passwordController.text = data['password']!;
          venu.value = data['venue_name']!;
          venuuuid.value = data['id']!;
          
          },
          (er) {
          Get.snackbar(
          "Error",
          "Error: $er",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black.withOpacity(0.5),
          colorText: Colors.red,
          duration: Duration(seconds: 15)
          
        );

          
          }
        );
       

   
      }
    });
  }
  void signOut() async {
    try{
      await disconnectFromWiFi();
    }catch(e){
      print(e);
    }
    try{
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
    await localStorage.remove('ssid');
    await localStorage.remove('password');
    await localStorage.remove('name');
    await localStorage.remove('email');
    await localStorage.remove('phone');
    await localStorage.remove('venu');
    Get.offAllNamed('/home');
  }

  @override
  void onClose() {
    ssidController.dispose();
    passwordController.dispose();
    disconnectTimer?.cancel();
    connectivityMonitor?.cancel();
    localStorage.remove('isFirstTime');
    controller?.dispose();
    super.onClose();
  }
}
