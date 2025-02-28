// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:free_y_fi/app/routes/app_pages.dart';
// import 'package:free_y_fi/app/services/device_info.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// class FacebookloginController extends GetxController {
//   final storage = GetStorage();

//   // Facebook Sign-in Function
//   Future<UserCredential?> signInWithFacebook() async {
//     try {
//       // Trigger the sign-in flow
//       final LoginResult loginResult = await FacebookAuth.instance.login(loginBehavior: LoginBehavior.nativeWithFallback);

//       // Check the login status
//       if (loginResult.status == LoginStatus.success) {
//         final accessToken = loginResult.accessToken;

//         if (accessToken != null && accessToken.tokenString.isNotEmpty) {
//           // Create a Facebook credential from the access token
//           final OAuthCredential facebookAuthCredential =
//               FacebookAuthProvider.credential(accessToken.tokenString);

//           // Sign in to Firebase with the Facebook credential
//           return await FirebaseAuth.instance
//               .signInWithCredential(facebookAuthCredential);
//         } else {
//           return null;
//         }
//       } else if (loginResult.status == LoginStatus.cancelled) {
//         return null;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       return null;
//     }
//   }

//   Future<void> signInFB () async {
//     final result=await signInWithFacebook();
//     if(result != null && result.user!=null){
//            if (storage.read('deviceid') == null) {
//         final result = await getDeviceInfo();
//         await storage.write('deviceid', result['device_id']);

//       }
//       if( storage.read('name') == null){

//         await storage.write('email', result.user!.email);
//         await storage.write('name', result.user!.displayName);
//         await storage.write('phone', result.user!.phoneNumber);

//       }
//       Get.offAllNamed(Routes.WIFICONNECT);
//       return;
//     }
//    else{
//      Get.snackbar(
//         "Error",
//         "Facebook login failed",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.black45,
//         colorText: Colors.red,
//       );
//    }

//   }

// }
