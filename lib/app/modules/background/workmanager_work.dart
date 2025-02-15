import 'package:workmanager/workmanager.dart';

void scheduleWiFiConnectTask(String ssid, String password) {
  final inputData = <String, dynamic>{
    'ssid': ssid,
    'password': password,
  };

  // Schedule background task
  Workmanager().registerOneOffTask(
    'wifi_connect_task',
    'wifi_connect_task',
    inputData: inputData,
    initialDelay: Duration(seconds: 10),
    constraints: Constraints(networkType: NetworkType.connected),
  );
}
