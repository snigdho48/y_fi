import 'package:flutter/material.dart';
import 'package:free_y_fi/app/data/url.dart';
import 'package:get/get.dart';
import 'package:one_request/one_request.dart';
import 'package:get_storage/get_storage.dart';

class PartnerdashboardController extends GetxController {
  //TODO: Implement PartnerdashboardController
  final request= oneRequest();
  final count = 0.obs;
  final venuedata = [].obs;
  final storage = GetStorage();
  final ssid = TextEditingController().obs;
  final password = TextEditingController().obs;
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
  void addVenueWifi(){
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
            controller: ssid.value,
            decoration: InputDecoration(
              hintText: "SSID",
            ),
          ),
          TextField(
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

void editVenueWifi(index){
  ssid.value.text = venuedata[index]['ssid'];
  password.value.text = venuedata[index]['password'];
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
            controller: ssid.value,
            decoration: InputDecoration(
              hintText: "SSID",
            ),
          ),
          TextField(
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
