import 'package:flutter/material.dart';
import 'package:free_y_fi/app/modules/webview/adwebview.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    controller;
    return Scaffold(
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(children: [
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   child: Container(
          //     height: (Get.height * 200) / 1920,
          //     width: Get.width,
          //     decoration: BoxDecoration(
          //       color: Colors.green,
          //     ),
          //     child: Center(
          //       child: Text(
          //         'Ad 1080x200',
          //         style:
          //             TextStyle(color: Colors.white, fontSize: Get.width * .05),
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/icon/logo.png',
                  width: Get.width * .6,
                ),
                SizedBox(height: Get.height * 0.02),
                RichText(
                    text: TextSpan(
                  text: 'Connect - Engage - Earn',
                  style:
                      TextStyle(fontSize: Get.width * .05, color: Colors.white),
                )),
              ],
            ),
          ),
            Positioned(
            bottom: 5,
            left: (Get.width - 300) / 2, // Centering the ad
            child: AnimatedOpacity(
              opacity: (MediaQuery.of(context).viewInsets.bottom > 0) ? 0 : 1,
              duration: Duration(
                  milliseconds:
                      MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 200),
              child: AdBanner(
                  width: 300,
                  height: 250,
                  content: 'https://ad.freeyfi.com/app_slots/login.html',
                  adUrl: 'https://google.com'),
            ),
          ),
        ]),
      ),
    );
  }
}
