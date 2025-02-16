import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../firebase_options.dart';
import '../../screens/chat_screen.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessageBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await NotificationServices.instance.initNotification();
  await NotificationServices.instance.showNotification(message);
}

class NotificationServices {
  NotificationServices._();
  static final instance = NotificationServices._();
  late GlobalKey<NavigatorState> _navigatorKey;

  void setNavigatorKey(GlobalKey<NavigatorState> key) {
    _navigatorKey = key;
  }

  final _messaging = FirebaseMessaging.instance;
  final _localNotificationPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessageBackgroundHandler);
    await requestPermission();
    await _setupMessageHandler();
    //print('init done');
  }

  //Request permission for notification

  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  //Initialize the notification plugin
  Future<void> initNotification() async {
    if (_isInitialized) return; //avoid reinitialization
    //android and ios settings
    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const notificationChannel = AndroidNotificationChannel(
        'daily_channel_id', 'Daily Notifications',
        description: 'Daily Notification Channel', importance: Importance.max);
    await _localNotificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(notificationChannel);

    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
        android: initSettingsAndroid, iOS: initSettingsIOS);

    await _localNotificationPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (response) async {
      if (response.payload != null) {
        print("${response.payload}\n${response}");
        try {
          Map<String, dynamic> data = jsonDecode(response.payload!);
          _handleBackgroundMessage(data);
        } catch (e) {
          print("Error decoding notification payload: $e");
        }
      }
      //print('Notification payload: $payload');
      // if (payload != null) {
      // }
    });
    _isInitialized = true;
  }

  //Notification Detail Setup
  NotificationDetails notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
          'daily_channel_id', 'Daily Notifications',
          channelDescription: 'Daily Notification Channel',
          importance: Importance.max,
          priority: Priority.high,
          enableVibration: true,
          playSound: true,
          icon: '@mipmap/ic_launcher'),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  //Show Notification
  Future<void> showNotification(RemoteMessage remoteMessage) async {
    final notification = remoteMessage.notification;
    final androidNotification = notification?.android;
    if (notification != null && androidNotification != null) {
      String jsonPayload = jsonEncode(remoteMessage.data);
      // print('${remoteMessage.data['type']} notification received'); //chat
      await _localNotificationPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        notificationDetails(),
        payload: jsonPayload,
      );
    }
  }

  Future<void> _setupMessageHandler() async {
    //foreground message , action is by onDidReceiveNotification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Don't show notification if user is in chat with sender
      final context = _navigatorKey.currentContext;
      if (context != null) {
        final currentRoute = ModalRoute.of(context);
        if (currentRoute != null && currentRoute.settings.name == 'chat') {
          final args = currentRoute.settings.arguments as Map<String, dynamic>?;
          if (args != null &&
              args['senderEmail'] == message.data['senderEmail']) {
            return;
          }
        }
      }
      showNotification(message);
    });

    //background message
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleBackgroundMessage(message.data);
    });

    //opened app from terminated state
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage.data);
    }
  }

  //invoked when app is relaunched after being minimized or terminated

  void _handleBackgroundMessage(Map<String, dynamic> message) {
    Future.delayed(Duration.zero, () async {
      try {
        final context = _navigatorKey.currentContext;
        if (context == null) {
          Future.delayed(
              Duration(seconds: 1), () => _handleBackgroundMessage(message));
          return;
        }

        final senderName = message['senderName'];
        final senderEmail = message['senderEmail'];
        // print("Navigating to chat...");

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              senderName: senderName,
              senderEmail: senderEmail,
            ),
          ),
        );
      } catch (e, stack) {
        print("Error in _handleBackgroundMessage: $e\n$stack");
      }
    });
  }
}
