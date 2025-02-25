import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wificonnect_controller.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class WificonnectView extends GetView<WificonnectController> {
  const WificonnectView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
   

      body: SingleChildScrollView(
        child: SizedBox(
          
          height: Get.height *.9115,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,      
            
                
                children: [
                  SizedBox(height: Get.height*.1,),
              Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 5,
              children: [
                 RichText(text: 
               TextSpan(
                 text: 'Scan QR Code to',
                 style: TextStyle(fontSize: Get.width*.07, fontWeight: FontWeight.normal,),
               )
               ),
                  RichText(
                          text: TextSpan(
                        text: 'Connect',
                        style: TextStyle(
                          fontSize: Get.width * .07,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightGreenAccent,
                        ),
                      )),
              ],
              ),
                   SizedBox(height: Get.height*.03),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: SizedBox(
                      
                      height: Get.width*.7,
                      width: Get.width*.7,
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
                        onQRViewCreated:controller.onQRViewCreated,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Obx(()  {
                    if (controller.qrCodeResult.isEmpty)
                    {
                      return const SizedBox.shrink();
                    }
                    
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 5,
                      children: [
                        RichText(
                            text: TextSpan(
                          text: 'Y-Fi Name:',
                          style: TextStyle(
                            fontSize: Get.width * .06,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreenAccent,
                          ),
                        )),
                        RichText(
                            text: TextSpan(
                          text: controller.qrCodeResult.isEmpty
                              ? ""
                              : controller.ssidController.text,
                          style: TextStyle(
                            fontSize: Get.width * .06,
                           
                          ),
                        )),
                      ],
                    );}
                  ),
                  Obx(() {
                    if (controller.qrCodeResult.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return ElevatedButton(
                      
                      onPressed: controller.isConnected.value 
                          ? controller.disconnectWiFi2
                          : controller.connectToWiFi,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 50),
                            backgroundColor: Colors.white,
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
                            
                          ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            controller.isConnected.value
                                ? "Disconnect"
                                : "Connect",
                            style: TextStyle(
                              fontSize: Get.width * .06,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            controller.isConnected.value
                                ? Icons.wifi_off
                                : Icons.wifi,
                            color: Colors.black,
                          ),
                        ],
                      )
                    );
                  }),
                  SizedBox(height: 20),
                  Obx(() => Text(
                        controller.isConnected.value 
                            ? "Connected! Disconnecting in: ${controller.remainingTime.value}s"
                            : "",
                        style: const TextStyle(

                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                      )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
