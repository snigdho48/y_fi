
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:free_y_fi/app/data/url.dart';
import 'package:free_y_fi/app/routes/app_pages.dart';
import 'package:free_y_fi/app/services/device_info.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get_storage/get_storage.dart';
import 'package:one_request/one_request.dart';
class GoogleloginController extends GetxController {
  final storage = GetStorage();
    final request = oneRequest();

  @override
  void onInit() {
    super.onInit();
  }



Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
  Future<void> signInGoogle() async {
    final result = await signInWithGoogle();
    print("Result: ${result.user}");
    if (result.user != null) {
      if (storage.read('deviceid') == null) {
        final result = await getDeviceInfo();
        storage.write('deviceid', result['device_id']);
       
      }
      

      final devicedata = await getDeviceInfo();
      final response = await request.send(
      url: '${baseurl}auth/login/',
        method: RequestType.POST,
        resultOverlay: true,
        body: {
          "email": result.user!.email,
          "password": result.user!.uid,
          "username": result.user!.displayName,
          "device_id": devicedata['device_id'],
          "device_name": devicedata['device_name'],
          "device_os": devicedata['device_os'],
          "device_brand": devicedata['device_brand'],

        },
      );
      response.fold((data) {
        storage.write('token', data['token']);
        storage.write('email', data['email']);
        storage.write('name', data['username']);
        storage.write('password', result.user!.uid);
        Get.snackbar(
          "Success",
          "Welcome ${data['username']}",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.black.withOpacity(0.5),
          colorText: Colors.green,
        );
        Get.offAllNamed(Routes.WIFICONNECT);
      }, (er) {
     
        print("Error: ${er}");
        
          Get.snackbar(
          "Error",
          "Error: $er",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black.withOpacity(0.5),
          colorText: Colors.red,
          duration: Duration(seconds: 15)
          
        );

      });
      return;
    }else{
      Get.snackbar(
        "Error",
        "Google login failed",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.5),
        colorText: Colors.red,
      );
    }
    
  }
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  } 
}