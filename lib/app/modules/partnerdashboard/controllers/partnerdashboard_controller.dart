import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:free_y_fi/app/data/url.dart';
import 'package:free_y_fi/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:one_request/one_request.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
class PartnerdashboardController extends GetxController {
  //TODO: Implement PartnerdashboardController
  final request = oneRequest();
  final count = 0.obs;
  final venuedata = [].obs;
  final storage = GetStorage();
  final ssid = TextEditingController().obs;
  final password = TextEditingController().obs;
  final qrData = ''.obs;
  @override
  void onInit() {
    routerData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

Future<bool> checkAndRequestPermissions({required bool skipIfExists}) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return false; // Only Android and iOS platforms are supported
    }

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;

      if (skipIfExists) {
        // Read permission is required to check if the file already exists
        return sdkInt >= 33
            ? await Permission.photos.request().isGranted
            : await Permission.storage.request().isGranted;
      } else {
        // No read permission required for Android SDK 29 and above
        return sdkInt >= 29
            ? true
            : await Permission.storage.request().isGranted;
      }
    } else if (Platform.isIOS) {
      // iOS permission for saving images to the gallery
      return skipIfExists
          ? await Permission.photos.request().isGranted
          : await Permission.photosAddOnly.request().isGranted;
    }

    return false; // Unsupported platforms
  }

  Future<void> routerData() async {
    print("Token: ${storage.read('token')}");
    try {
      final response = await request.send(
        url: '${baseurl}venue/data/list/',
        method: RequestType.GET,
        header: {
          "Authorization": "Bearer ${storage.read('token')}",
          'Content-Type': 'application/json',
        },
        resultOverlay: false,
      );
      response.fold((data) {
        venuedata.clear();
        venuedata.addAll(data);
        print("Data: $data");
        Get.snackbar(
          "Success",
          "Welcome ${data['username']}",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.black.withOpacity(0.5),
          colorText: Colors.green,
        );
      }, (er) {
        print("Error: ${er}");

        Get.snackbar("Error", "Error: $er",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black.withOpacity(0.5),
            colorText: Colors.red,
            duration: Duration(seconds: 15));
      });
    } catch (e) {
      print(e);
    }
  }

  void addVenueWifi() {
    Get.defaultDialog(
      title: "Add Venue Wifi",
      confirm: ElevatedButton(
        onPressed: () {
          _addVenue();
          Get.back();
        },
        child: Text("Add"),
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text("Cancel"),
      ),
      content: Column(
        children: [
          TextField(
            style: TextStyle(color: Colors.black),
            controller: ssid.value,
            decoration: InputDecoration(
              hintText: "SSID",
            ),
          ),
          TextField(
            style: TextStyle(color: Colors.black),
            controller: password.value,
            decoration: InputDecoration(
              hintText: "Password",
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addVenue() async {
    print("Token: ${storage.read('token')}");
    try {
      final response = await request.send(
        url: '${baseurl}venue/wifi/add/',
        method: RequestType.POST,
        header: {
          "Authorization": "Bearer ${storage.read('token')}",
          'Content-Type': 'application/json',
        },
        body: {
          "ssid": ssid.value.text,
          "password": password.value.text,
        },
        resultOverlay: false,
      );
      response.fold((data) {
        venuedata.clear();
        venuedata.addAll(data);
        print("Data: $data");
        Get.snackbar(
          "Success",
          "successfully added",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.black.withOpacity(0.5),
          colorText: Colors.green,
        );
      }, (er) {
        print("Error: ${er}");

        Get.snackbar("Error", "Error: $er",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black.withOpacity(0.5),
            colorText: Colors.red,
            duration: Duration(seconds: 15));
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> downloadQr(int index) async {
    qrData.value = 'https://app.freeyfi.com/?code=${venuedata[index]['code']}';
    // if (await Permission.photos.request().isDenied) {
    //   await Permission.photos.request(); // Request again
    //   print(await Permission.photos.status);
    //   if (await Permission.photos.isDenied) {
    //     Get.snackbar(
    //         "Permission Denied", "Storage access is required to save the file.",
    //         snackPosition: SnackPosition.TOP,
    //         backgroundColor: Colors.black.withOpacity(0.5),
    //         colorText: Colors.red,
    //         duration: Duration(seconds: 5));
    //     return;
    //   }
    // }
    ;

    // Special handling for Android 11+
    if (await Permission.photos.request().isDenied) {
      Get.snackbar("Permission Denied",
          "Storage permission is required for saving the QR Code.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.black.withOpacity(0.5),
          colorText: Colors.red,
          duration: Duration(seconds: 5));
      return;
      
    }

    // Create Screenshot Controller
    ScreenshotController screenshotController = ScreenshotController();

    try {
      // Request Storage Permission
      
      Get.defaultDialog(
        title: "QR Code",
        content: Container(
          color: Colors.white,
          height: Get.width * .8,
          width: Get.width * .8,
          padding: EdgeInsets.all(10),
          child: Screenshot(
            controller: screenshotController,
            child: QrImageView(
              data: qrData.value,
              version: QrVersions.auto,
              size: 2048,
              gapless: false,
              backgroundColor: Colors.white,
              embeddedImage: AssetImage('assets/icon/app_logo.png'),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Close"),
          ),
          ElevatedButton(
            onPressed: () async {
              await _captureAndDownloadQr(screenshotController, index);
            },
            child: Text("Download"),
          ),
        ],
      );
    } catch (e) {
      print("Error generating QR Code: $e");
      Get.snackbar("Error", "Failed to generate QR Code: $e",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.black.withOpacity(0.5),
          colorText: Colors.red,
          duration: Duration(seconds: 5));
    }
  }
  void logout() {
    storage.erase();
    Get.offAllNamed(Routes.USERLOGIN);
  }
// Capture the QR code and save it as an image
  Future<void> _captureAndDownloadQr(
      ScreenshotController screenshotController, int index) async {
    try {
      // Capture Screenshot
      Uint8List? pngBytes =
          await screenshotController.capture(pixelRatio: 2048 / 1000);
      if (pngBytes == null) {
        throw Exception("Failed to capture QR image");
      }
  
      // Ask user for directory to save
      final success =
              await SaverGallery.saveImage(
       pngBytes,
        quality: 100,
        extension: 'JPG',
        fileName: 'qr_code_${venuedata[index]['ssid']}',
        androidRelativePath: "Pictures/yfi/qrcodes",
        skipIfExists: false,
      );

          if (success.isSuccess == true) {
            Get.snackbar("Success", "QR Code saved to Gallery",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.black.withOpacity(0.5),
                colorText: Colors.green);
          } else {
            throw Exception("Failed to save image to gallery");
          }
    } catch (e) {
      print("Error capturing QR Code: $e");
      Get.snackbar("Error", "Failed to save QR Code: $e",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.black.withOpacity(0.5),
          colorText: Colors.red,
          duration: Duration(seconds: 5));
    }
  }

    

  Future<void> openFile(String folderPath) async {
    final Uri _uri = Uri.parse(folderPath);
    if (await canLaunch(_uri.toString())) {
      await launch(_uri.toString());
    } else {
      throw 'Could not launch $_uri';
    }
  }

  void editVenueWifi(index) {
    ssid.value.text = venuedata[index]['ssid'] ?? '';
    password.value.text = venuedata[index]['password'] ?? '';
    Get.defaultDialog(
      title: "Edit Wifi ${venuedata[index]['ssid']}",
      confirm: ElevatedButton(
        onPressed: () {
          editVenue();
          Get.back();
        },
        child: Text("Edit"),
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text("Cancel"),
      ),
      content: Column(
        children: [
          TextField(
            style: TextStyle(color: Colors.black),
            controller: ssid.value,
            decoration: InputDecoration(
              hintText: "SSID",
            ),
          ),
          TextField(
            style: TextStyle(color: Colors.black),
            controller: password.value,
            decoration: InputDecoration(
              hintText: "Password",
            ),
          ),
        ],
      ),
    );
  }

  Future<void> editVenue() async {
    print("Token: ${storage.read('token')}");
    try {
      final response = await request.send(
        url: '${baseurl}venue/wifi/update/',
        method: RequestType.POST,
        header: {
          "Authorization": "Bearer ${storage.read('token')}",
          'Content-Type': 'application/json',
        },
        body: {
          "password": password.value.text,
          "ssid": ssid.value.text,
        },
        resultOverlay: false,
      );
      response.fold((data) {
        venuedata.clear();
        venuedata.addAll(data);
        Get.snackbar(
          "Success",
          "successfully updated",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.black.withOpacity(0.5),
          colorText: Colors.green,
        );
      }, (er) {
        print("Error: ${er}");

        Get.snackbar("Error", "Error: $er",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black.withOpacity(0.5),
            colorText: Colors.red,
            duration: Duration(seconds: 15));
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteVenue(index) async {
    print("Token: ${storage.read('token')}");
    try {
      final response = await request.send(
        url: '${baseurl}venue/wifi/delete/',
        method: RequestType.POST,
        header: {
          "Authorization": "Bearer ${storage.read('token')}",
          'Content-Type': 'application/json',
        },
        body: {
          "code": venuedata[index]['code'],
        },
        resultOverlay: false,
      );
      response.fold((data) {
        print("Data: $data");
        venuedata.remove(venuedata[index]);
        Get.snackbar(
          "Success",
          "successfully deleted",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.black.withOpacity(0.5),
          colorText: Colors.green,
        );
      }, (er) {
        print("Error: ${er}");

        Get.snackbar("Error", "Error: $er",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black.withOpacity(0.5),
            colorText: Colors.red,
            duration: Duration(seconds: 15));
      });
    } catch (e) {
      print(e);
    }
  }
}
