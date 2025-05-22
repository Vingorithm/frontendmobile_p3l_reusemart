import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontendmobile_p3l_reusemart/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await _initializeLocalNotification();
    await _showFlutterNotification(message);
  }

  /// Initializes Firebase Messaging and Local Notifications
  static Future<void> initializeNotification() async {
    // Request permissions (required on iOS, optional on Android)
    await _firebaseMessaging.requestPermission();

    // Called when message is received while app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _showFlutterNotification(message);
    });

    // Called when app is brought to foreground from background by tapping
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("App opened from background notification: ${message.data}");
    });

    // Get and print FCM token (for sending targeted messages)
    await _getFcmToken();

    // Initialize the local notification plugin
    await _initializeLocalNotification();

    // Check if app was launched by tapping on a notification
    await _getInitialNotification();
  }

  static Future<void> _getInitialNotification() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print("App launched from terminated state by notification: ${initialMessage.data}");
      await _showFlutterNotification(initialMessage);
    }
  }

  static Future<void> _getFcmToken() async {
    String? token = await _firebaseMessaging.getToken();
    print('FOM Token: $token');
  }

  static Future<void> _showFlutterNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    Map<String, dynamic>? data = message.data;

    String title = notification?.title?? data['title'] ?? 'No Title';
    String body = notification?.body ?? data['body'] ?? 'No Body';

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'Notification channel for basic tests',
      priority: Priority.high,
      importance: Importance.high,
    );

    DarwinNotificationDetails iOSDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  static Future<void> _initializeLocalNotification() async {
    const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@drawable/ic_launcher');
    const DarwinInitializationSettings iOSInit = DarwinInitializationSettings();

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iOSInit,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("User tapped notification: ${response.payload}");
      },
    );
  }
}