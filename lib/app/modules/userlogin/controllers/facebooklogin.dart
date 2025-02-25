import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:free_y_fi/app/routes/app_pages.dart';
import 'package:get/get.dart';

class FacebookloginController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  // Facebook Sign-in Function
  Future<UserCredential?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Check the login status
      if (loginResult.status == LoginStatus.success) {
        final accessToken = loginResult.accessToken;

        if (accessToken != null && accessToken.tokenString.isNotEmpty) {
          // Create a Facebook credential from the access token
          final OAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(accessToken.tokenString);

          // Sign in to Firebase with the Facebook credential
          return await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential);
        } else {
          print("Access Token is null or empty.");
          return null;
        }
      } else if (loginResult.status == LoginStatus.cancelled) {
        print("Facebook login was cancelled by the user.");
        return null;
      } else {
        print("Facebook login failed: ${loginResult.message}");
        return null;
      }
    } catch (e) {
      print("An error occurred during Facebook login: $e");
      return null;
    }
  }

  Future<void> signInFB () async {
    final result=await signInWithFacebook();
    if(result?.user!=null){
      Get.offAllNamed(Routes.WIFICONNECT);
    }
    Get.snackbar(
      "Error",
      "Facebook login failed",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.5),
      colorText: Colors.red,
    );
    

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
