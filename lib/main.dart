import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bitmap/bitmap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterNotification =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    const androidInitilize = AndroidInitializationSettings('app_icon');
    const iOSinitilize = IOSInitializationSettings();
    const initilizationsSettings = InitializationSettings(
      android: androidInitilize,
      iOS: iOSinitilize,
    );
    flutterNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
  }

  void notificationSelected(String? payload) async {
    print(payload);
  }

  Future _showNotification() async {
    Bitmap bitmap = await Bitmap.fromProvider(const NetworkImage(
        "https://robertatkinson61.files.wordpress.com/2019/05/img_5547.jpg"));
    Uint8List headedBitmap = bitmap.buildHeaded();
    AndroidBitmap<Object> androidBitmap =
        ByteArrayAndroidBitmap.fromBase64String(base64Encode(headedBitmap));
    final androidDetails = AndroidNotificationDetails(
      "Channel ID",
      "Channel Name",
      channelDescription: "This is my channel",
      importance: Importance.max,
      color: Colors.blue,
      largeIcon: androidBitmap,
    );
    const iOSDetails = IOSNotificationDetails();
    final generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await flutterNotification.show(
        1, "Task", "You created a Task", generalNotificationDetails,
        payload: "Task");
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _showNotification,
                child: Container(
                  width: 200,
                  child: const Text(
                    "Press To Generate A Notification!",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
