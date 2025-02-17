import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wificonnect_controller.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class WificonnectView extends GetView<WificonnectController> {
  const WificonnectView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
   appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          padding:  EdgeInsets.only(top:MediaQuery.of(context).padding.top),
          height: Get.height * .1,
          width: Get.width,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
           
            gradient: LinearGradient(
              colors: [const Color.fromARGB(255, 0, 149, 229), const Color.fromARGB(255, 1, 93, 252)], // Colors for the gradient
              begin: Alignment.topLeft, // Starting point of the gradient
              end: Alignment.bottomRight, // End point of the gradient
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
            
              const Text(
                'WiFi Connect',
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
           decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color.fromARGB(255, 59, 160, 244), const Color.fromARGB(255, 0, 195, 255)], // Colors for the gradient
              begin: Alignment.topLeft, // Starting point of the gradient
              end: Alignment.bottomRight, // End point of the gradient
            ),
          ),
          height: Get.height *.9115,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,      
            
                
                children: [
                  Container(
                     decoration: BoxDecoration(
                      color: Colors.blue, // Background color
                      borderRadius: BorderRadius.circular(20), // Rounded border
                      border: Border.all(
                          color: Colors.white,
                          width: 2), // Border color & thickness
                    ),
                    height: Get.width,
                    width: Get.width,
                    child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Apply clippingr
                      child: QRView(
                        key: controller.qrKey,
                        overlay: QrScannerOverlayShape(
                            borderColor: Colors.red,
                            borderRadius: 10,
                            borderLength: 30,
                            borderWidth: 10,
                            cutOutSize: 300),
                        onQRViewCreated:controller.onQRViewCreated,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Obx(() => Text(
                        controller.qrCodeResult.isEmpty
                            ? 'Scan a QR Code'
                            : 'WiFi: ${controller.ssidController.text}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                 
                  const SizedBox(height: 20),
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
                      child: Text(
                          controller.isConnected.value ? "Disconnect" : "Connect",style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                          ),),
                    );
                  }),
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
