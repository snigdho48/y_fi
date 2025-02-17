import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// Initialize notifications
Future<void> initializeNotifications() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
          '@mipmap/ic_launcher'); // Make sure to use the correct icon name

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  // Initialize the notification plugin
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        onDidReceiveNotificationResponse, // Handle foreground notification tap
    onDidReceiveBackgroundNotificationResponse:
        onDidReceiveBackgroundNotificationResponse, // Handle background notification tap
  );
}

// Notification response when tapped (foreground)
Future<void> onDidReceiveNotificationResponse(
    NotificationResponse response) async {
  print('Notification tapped with payload: ${response.payload}');
  // Handle the notification tap and navigate if necessary
}

// Notification response when tapped (background)
Future<void> onDidReceiveBackgroundNotificationResponse(
    NotificationResponse response) async {
  print('Background notification tapped with payload: ${response.payload}');
  // Handle background notification tap and navigate if necessary
}

// Show a notification
void showNotification(String title, String body) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    '10', // Channel ID
    'y_fi_notifications', // Channel Name
    channelDescription: 'Channel for notifications',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    10, // Notification ID
    title,
    body,
    platformChannelSpecifics,
    payload:
        'Optional Payload', // This is the payload data passed to the callback
  );
}
