import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wificonnect_controller.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class WificonnectView extends GetView<WificonnectController> {
  const WificonnectView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("WiFi Connection")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,      
        
            
            children: [
              SizedBox(
                height: 300,
                width: 300,
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
              Obx(() => Text(
                    controller.qrCodeResult.isEmpty
                        ? 'Scan a QR Code'
                        : 'Scanned Code: ${controller.ssidController.text}',
                    style: const TextStyle(fontSize: 16),
                  )),
             
              const SizedBox(height: 20),
              Obx(() {
                if (controller.qrCodeResult.isEmpty) {
                  return const SizedBox.shrink();
                }
                return ElevatedButton(
                  onPressed: controller.isConnected.value
                      ? controller.disconnectWiFi
                      : controller.connectToWiFi,
                  child: Text(
                      controller.isConnected.value ? "Disconnect" : "Connect"),
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
    );
  }
}
