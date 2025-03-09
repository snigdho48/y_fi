import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:free_y_fi/app/modules/webview/adwebview.dart';
import 'package:get/get.dart';
import '../controllers/wificonnect_controller.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class WificonnectView extends GetView<WificonnectController> {
  const WificonnectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            MediaQuery.of(context).padding.top), // Custom height
        child: SizedBox(
          height: kToolbarHeight + MediaQuery.of(context).padding.top,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Obx(() {
                if (!controller.isLoading.value) {
                  return IconButton(
                    onPressed: () {
                      if (controller.isConnected.value) {
                        controller.disconnectWiFi2();
                      }
                      controller.signOut();
                    },
                    icon: Icon(Icons.logout, color: Colors.white),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: Get.height * .92,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 5,
                          children: [
                            RichText(
                                text: TextSpan(
                              text: controller.isConnected.value
                                  ? 'Connected To'
                                  : controller.isRun.value
                                      ? 'Reconnect to'
                                      : 'Scan QR Code to',
                              style: TextStyle(
                                fontSize: controller.isConnected.value
                                    ? Get.width * .05
                                    : Get.width * .07,
                                fontWeight: FontWeight.normal,
                              ),
                            )),
                            RichText(
                                text: TextSpan(
                              text: controller.isConnected.value
                                  ? ' ${controller.ssidController.text}'
                                  : controller.isRun.value
                                      ? 'Free Y-Fi'
                                      : 'Connect',
                              style: TextStyle(
                                fontSize: controller.isConnected.value
                                    ? Get.width * .05
                                    : Get.width * .07,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightGreenAccent,
                              ),
                            )),
                          ],
                        ),
                      ),
                      SizedBox(height: Get.height * .03),
                      Obx(() {
                        if (!controller.isConnected.value &&
                            !controller.isRun.value) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: SizedBox(
                              height: Get.width * .7,
                              width: Get.width * .7,
                              child: QRView(
                                overlayMargin: EdgeInsets.zero,
                                key: controller.qrKey,
                                overlay: QrScannerOverlayShape(
                                    borderColor: Colors.lightGreenAccent,
                                    borderRadius: 5,
                                    borderLength: 50,
                                    borderWidth: 10,
                                    overlayColor: Colors.black.withAlpha(100),
                                    cutOutSize: Get.width * 0.7),
                                onQRViewCreated: controller.onQRViewCreated,
                              ),
                            ),
                          );
                        }
                        return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.lightGreenAccent,
                                width: 2,
                              ),
                              borderRadius:
                                  BorderRadius.circular(Get.width * .5),
                            ),
                            height: Get.width * .5,
                            width: Get.width * .5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${(controller.remainingTime.value ~/ 3600).toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                          fontSize: Get.width * .08,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      ' : ',
                                      style: TextStyle(
                                          fontSize: Get.width * .08,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.lightGreenAccent),
                                    ),
                                    Text(
                                      '${((controller.remainingTime.value % 3600) ~/ 60).toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                          fontSize: Get.width * .08,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      ' : ',
                                      style: TextStyle(
                                          fontSize: Get.width * .08,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.lightGreenAccent),
                                    ),
                                    Text(
                                      '${(controller.remainingTime.value % 60).toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                          fontSize: Get.width * .08,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                Text(
                                  controller.isRun.value
                                      ? 'Session Expired'
                                      : 'Remaining Time',
                                  style: TextStyle(
                                    fontSize: Get.width * .04,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ));
                      }),
                      SizedBox(height: 20),
                      Obx(() {
                        if (controller.venu.value.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 5,
                          children: [
                            RichText(
                                text: TextSpan(
                              text: controller.isConnected.value
                                  ? 'Y-Fi Partner: '
                                  : controller.isRun.value
                                      ? 'Reconnect: '
                                      : 'Y-Fi Name:',
                              style: TextStyle(
                                fontSize: Get.width * .05,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightGreenAccent,
                              ),
                            )),
                            RichText(
                                text: TextSpan(
                              text: controller.qrCodeResult.isEmpty
                                  ? ""
                                  : controller.isConnected.value
                                      ? controller.venu.value
                                      : controller.isRun.value
                                          ? 'Your Session Expired'
                                          : controller.ssidController.text,
                              style: TextStyle(
                                fontSize: Get.width * .05,
                              ),
                            )),
                          ],
                        );
                      }),
                      SizedBox(height: Get.height * .02),
                      Obx(() {
                        if (controller.venu.value.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return ElevatedButton(
                            onPressed: controller.isConnected.value
                                ? controller.disconnectWiFi2
                                : controller.startloadingTimer,
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(Get.width * .5, 60),
                              maximumSize: Size(Get.width * .75, 60),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              shadowColor: Colors.black,
                              elevation: 5,
                              side: const BorderSide(
                                color: Colors.black,
                                width: .2,
                              ),
                              backgroundColor: Colors.lightGreenAccent,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    text: TextSpan(
                                  text: controller.isConnected.value
                                      ? "Disconnect"
                                      : "Get",
                                  style: TextStyle(
                                    fontSize: Get.width * .05,
                                    color: Color(0xFF191B41),
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration
                                        .underline, // Underline the text
                                    decorationColor: Colors
                                        .black, // Optional: Set the underline color
                                    decorationStyle: TextDecorationStyle
                                        .solid, // Solid underline
                                    decorationThickness: 1,
                                    height: 1.3,
                                  ),
                                )),
                                Row(
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                      text: controller.isConnected.value
                                          ? ""
                                          : " Free Y-Fi",
                                      style: TextStyle(
                                        fontSize: Get.width * .05,
                                        color: Color(0xFF191B41),
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration
                                            .underline, // Underline the text
                                        decorationColor: Colors
                                            .black, // Optional: Set the underline color
                                        decorationStyle: TextDecorationStyle
                                            .solid, // Solid underline
                                        decorationThickness: 1,
                                        height: 1.3,
                                      ),
                                    )),
                                  ],
                                ),
                              ],
                            ));
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Obx(() {
            if (!controller.isConnected.value) {
              return Positioned(
              bottom:0,
                left: (Get.width - 320) / 2,
                child: AdBanner(width: 320, height: 100, content: 'https://creatives.reachableads.com/gozayan/320x100', adUrl: 'https://google.com'),
              );
            }
            return const SizedBox(
              height: 0,
            );
          }),
          Obx(() {
            if (controller.isConnected.value) {
              return Positioned(
                bottom: 0,
                left: (Get.width - 320) / 2,
                child: AdBanner(width: 320, height: 50, content:    'https://creatives.reachableads.com/gozayan/320x50', adUrl: 'https://google.com'),
              );
            }
            return const SizedBox(
              height: 0,
            );
          }),
          Obx(() {
            if (controller.isLoading.value) {
              return Positioned(
                top: 0,
                left: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: controller.isLoading.value ? 1 : 0,
                  child: Container(
                    color: Color(0xFF191B41),
                    height: Get.height,
                    width: Get.width,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 5,
                            children: [
                              RichText(
                                  text: TextSpan(
                                text: 'Connecting To',
                                style: TextStyle(
                                  fontSize: Get.width * .05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightGreenAccent,
                                ),
                              )),
                              RichText(
                                  text: TextSpan(
                                text: 'Free Y-Fi',
                                style: TextStyle(
                                  fontSize: Get.width * .05,
                                ),
                              )),
                            ],
                          ),
                          SizedBox(height: Get.height * .03),
                          AdBanner(width: Get.width, height: Get.height*.7,adheight: '250',adwidth: '300', content: 'https://creatives.reachableads.com/gozayan/300x250', adUrl: 'https://google.com'),
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.width * .1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Ad Ends in: ',
                                      style: TextStyle(
                                        fontSize: Get.width * .05,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Obx(
                                      () => Container(
                                        constraints: BoxConstraints(
                                            minWidth: Get.width * .06),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${controller.loadingCount.value}',
                                          style: TextStyle(
                                            fontSize: Get.width * .05,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.lightGreenAccent,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Sec',
                                      style: TextStyle(
                                        fontSize: Get.width * .05,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  FontAwesomeIcons.clock,
                                  color: Colors.lightGreenAccent,
                                )
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox(
              height: 0,
            );
          }),
        ],
      ),
    );
  }
}
