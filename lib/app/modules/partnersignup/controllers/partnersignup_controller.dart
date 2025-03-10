import 'package:flutter/material.dart';
import 'package:free_y_fi/app/data/url.dart';
import 'package:free_y_fi/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:one_request/one_request.dart';


class PartnersignupController extends GetxController {
  //TODO: Implement PartnersignupController
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final usernameController = TextEditingController().obs;
  final addressController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;
  final isPasswordVisible = false.obs;
  final isCheck = false.obs;
  final count = 0.obs;
  final storage = GetStorage();
  final request = oneRequest();
  @override
  void onInit() {
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

    void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value; // Toggle visibility
  }

  bool validatePhone(String? value) {
    if (value == null) {
      return false;
    }
    if (value.isEmpty) {
      return false;
    }
    if (value.length < 10) {
      return false;
    }
    if (!GetUtils.hasMatch(value, r'[0-9]')) {
      return false;
    }
    if (!GetUtils.isPhoneNumber(value)) {
      return false;
    }
    return true;
  }

   bool validateEmail(String? value) {
    if (value == null) {
      return false;
    }
    if (value.isEmpty) {
      return false;
    }
    if (!GetUtils.isEmail(value)) {
      return false;
    }
    return true;
  }

  bool passwordValidation(String? value) {
    if (value == null) {
      return false;
    }
    if (value.isEmpty) {
      return false;
    }
    if (value.length < 6) {
      return false;
    }
    if (!GetUtils.hasMatch(value, r'[0-9]')) {
      return false;
    }
    return true;
  }
  Future<void> signup() async {
    if(!isCheck.value){
      Get.snackbar(
        "Error",
        "Please check the terms and conditions",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black.withOpacity(0.5),
        colorText: Colors.red,
                  duration: Duration(seconds: 5),

      );
      return;
    }
   if(validateEmail(emailController.value.text) && passwordValidation(passwordController.value.text) && usernameController.value.text.isNotEmpty ){
     try{
       final response = await request.send(
        url: '${baseurl}auth/partner/register/',
        method: RequestType.POST,
        resultOverlay: true,
        body: {
            "username": usernameController.value.text,
            "userpassword": passwordController.value.text,
            "email": emailController.value.text,
            "venue_name": usernameController.value.text,
            "address": addressController.value.text,
            "phone_number": phoneController.value.text,
        
        },
      );
      response.fold((data) {
        print('Data: $data');
        storage.write('token', data['token']);
        storage.write('email', data['email']);
        storage.write('name', data['username']);
        storage.write('group_name', data['group_name']);
        Get.snackbar(
          "Success",
          "Welcome ${data['username']}",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.black.withOpacity(0.5),
          colorText: Colors.green,
        );
        Get.offAllNamed(Routes.PARTNERDASHBOARD);
      }, (er) {
        print("Error: ${er}");

        Get.snackbar("Error", "Error: $er",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.black.withOpacity(0.5),
            colorText: Colors.red,
            duration: Duration(seconds: 5));
      });
     }catch(e){
       print(e);
     }
   }else{
     Get.snackbar(
         "Error",
         "Something went wrong",
         snackPosition: SnackPosition.TOP,
         backgroundColor: Colors.black.withOpacity(0.5),
         colorText: Colors.red,
                   duration: Duration(seconds: 5),

       );
   }
  }
}
