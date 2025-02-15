import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessageBackgroundHandler(RemoteMessage message) async {
  await NotificationServices.instance.initNotification();
  await NotificationServices.instance.showNotification(message);
}

class NotificationServices {
  NotificationServices._();
  static final instance = NotificationServices._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotificationPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessageBackgroundHandler);
    //request permission
    await requestPermission();
    //setup message handlers
    await _setupMessageHandler();

    //Get FCM token
    final token = await _messaging.getToken();
    print('FCM Token: $token');
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
      final payload = response.payload;
      if (payload != null) {
        print('Notification payload: $payload');
        //Handle notification payload here and can add navigation to specific screen
      }
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
      await _localNotificationPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        notificationDetails(),
        payload: remoteMessage.data.toString(),
      );
    }
  }

  Future<void> _setupMessageHandler() async {
    //foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      showNotification(message);
    });

    //background message
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    //opened app
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    print('Handling a background message ${message.messageId}');
    if (message.data['type'] == 'chat') {
      //Navigate to specific screen based on the payload
    }
  }

//on Tap Notification
}
