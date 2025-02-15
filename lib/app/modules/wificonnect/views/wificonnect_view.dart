import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wificonnect_controller.dart';

class WificonnectView extends GetView<WificonnectController> {

  const WificonnectView({super.key});

  @override
  Widget build(BuildContext context) {
 

    return Scaffold(
      appBar: AppBar(title: const Text("WiFi Connection")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.ssidController,
              decoration: const InputDecoration(labelText: "WiFi SSID"),
            ),
            TextField(
              controller: controller.passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
        Obx(() {
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}
