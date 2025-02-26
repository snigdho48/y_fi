
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:free_y_fi/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';
import 'package:get_storage/get_storage.dart';
class GoogleloginController extends GetxController {
  final storage = GetStorage();
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
        final deviceid = await MobileDeviceIdentifier().getDeviceId();
        storage.write('deviceid', deviceid);
       
      }
      if( storage.read('name') == null){
 
        await storage.write('email', result.user!.email);
        await storage.write('name', result.user!.displayName);
        await storage.write('phone', result.user!.phoneNumber);
        print("Stored name: ${storage.read('name')}");

      }

      Get.offAllNamed(Routes.WIFICONNECT);
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