import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dart_ipify/dart_ipify.dart';

Future<Map<String, String>> getDeviceInfo() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceId = "Unknown";
  String deviceName = "Unknown";
  String osVersion = "Unknown";
  String brand = "Unknown";
  String ip = "Unknown";

  if (Platform.isAndroid) {
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.id; // Unique device ID
    deviceName = androidInfo.model; // Device model
    brand = androidInfo.manufacturer; // Brand name (Samsung, Xiaomi, etc.)
    osVersion = "Android ${androidInfo.version.release}"; // OS version
  } else if (Platform.isIOS) {
    final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor ?? "Unknown"; // Unique ID
    deviceName = iosInfo.name; // Device name
    brand = "Apple"; // iOS devices are always Apple
    osVersion = "iOS ${iosInfo.systemVersion}"; // OS version
  }
  try {
    ip = await Ipify.ipv4(); // Get the public IPv4 address
  } catch (e) {
    ip = "Unable to fetch IP";
  }
  return {
    "device_id": deviceId,
    "device_name": deviceName,
    "device_os": osVersion,
    "device_brand": brand,
    "ip": ip,
  };
}
