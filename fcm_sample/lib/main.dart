import 'dart:convert';
import 'dart:io';

import 'package:fcm_sample/firebase_options.dart';
import 'package:fcm_sample/webviewscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(const MyApp());
}

// Future<void> _messageHandler(RemoteMessage message) async {
//   print('background message ${message.notification!.body}');
// }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      routes: {WebviewScreen.routeName: (ctx) => const WebviewScreen()},
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FirebaseMessaging messaging;
  String? _token;
  int _messageCount = 0;

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      print(
          'Get title message from getInitialmessage: ${initialMessage.notification?.title}');
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    //when fcm sends push notification and if the app is in the foreground the below code will be executed
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      RemoteNotification? notification = event.notification;
      AndroidNotification? android = event.notification?.android;

      //we create a custom notification channel which lets us explicitly allow to show notificaition even when the app is in the foreground but for default notification channel of firebase it's not possible
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
                // other properties...
              ),
            ),
            payload: json.encode(event.data));
      }
      //the above code makes notification pop on the notification screen of android app and when the user press on that notification then the onMessageOpenApp is triggered with the value we provided above.

      print("message recieved");
      print(event.notification!.body);
      print("event data payload : ${event.data.values}");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Notification"),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  void _handleMessage(RemoteMessage message) {
    print('onmessageapp $message');
    if (message.data['type'] == 'chat') {
      // Navigator.pushNamed(context, '/chat',
      //   arguments: ChatArguments(message),
      // );
    }
  }

  //scheduled notification
  Future<void> _scheduleNotification(RemoteNotification message,
      AndroidNotificationChannel channel, String? iconName) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        message.hashCode,
        message.title,
        message.body,
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 3)),
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: iconName,
            // other properties...
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: "",
        androidAllowWhileIdle: true);
  }

  @override
  void initState() {
    setupInteractedMessage();
    messaging = FirebaseMessaging.instance;
    _getToken();
    super.initState();
  }

  Future<void> _getToken() async {
    _token = await messaging.getToken();
  }

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FCM Test'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: Text('show local notification'),
              onPressed: () async {
                //sending local push notification to the app itself
                var androidPlatformChannelSpecifics =
                    const AndroidNotificationDetails(
                  'parentry',
                  'Important Notifications',
                  channelDescription:
                      'This channel is used for important notifications',
                  importance: Importance.max,
                  priority: Priority.high,
                  icon: '@mipmap/ic_launcher',
                );
                var iOSPlatformChannelSpecifics = IOSNotificationDetails();
                var platformChannelSpecifics = NotificationDetails(
                    android: androidPlatformChannelSpecifics,
                    iOS: iOSPlatformChannelSpecifics);
                await _flutterLocalNotificationsPlugin.show(
                    1, 'plain title', 'plain body', platformChannelSpecifics,
                    payload: 'item x');
              },
            ),
            ElevatedButton(
                onPressed: () {}, child: const Text('send push message')),
          ],
        ),
      ),
    );
  }
}
