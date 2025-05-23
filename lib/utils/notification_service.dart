// lib/services/notification_service.dart - Perbaikan
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import '../data/api_service.dart';
import '../data/services/auth_service.dart';
import '../firebase_options.dart';
import '../utils/tokenUtils.dart';
import 'dart:convert';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Initializes Firebase Messaging and Local Notifications
  static Future<void> initializeNotification() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // Request permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission for notifications');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User denied notification permissions');
      return; // Jangan lanjut jika permission ditolak
    }

    // Initialize local notifications first
    await _initializeLocalNotification();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("Foreground message received: ${message.messageId}");
      await _showFlutterNotification(message);
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Handle app opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("App opened from background notification: ${message.data}");
      _handleNotificationNavigation(message);
    });

    // Handle app launched from terminated state
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print("App launched from terminated state: ${initialMessage.data}");
      // Delay navigation untuk memastikan app sudah fully loaded
      Future.delayed(const Duration(seconds: 2), () {
        _handleNotificationNavigation(initialMessage);
      });
    }

    // Get and print FCM token for debugging
    String? token = await _firebaseMessaging.getToken();
    print('Initial FCM Token: $token');
  }

  /// Background message handler
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    print("Background message received: ${message.messageId}");
    await _initializeLocalNotification();
    await _showFlutterNotification(message);
  }

  /// Shows local notification
  static Future<void> _showFlutterNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    Map<String, dynamic>? data = message.data;

    String title = notification?.title ?? data['title'] ?? 'Notifikasi Baru';
    String body = notification?.body ?? data['body'] ?? 'Anda memiliki notifikasi baru';

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'reusemart_channel',
      'ReuseMart Notifications',
      channelDescription: 'Notifications for ReuseMart app',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    try {
      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/  1000, // Unique ID
        title,
        body,
        notificationDetails,
        payload: jsonEncode(data ?? {}),
      );
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  /// Initializes local notification plugin
  static Future<void> _initializeLocalNotification() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@drawable/ic_launcher');
    
    const DarwinInitializationSettings iOSInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iOSInit,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          print("User tapped notification: ${response.payload}");
          _handleNotificationNavigationFromPayload(response.payload!);
        }
      },
    );
  }

  /// Handles navigation based on notification data
  static void _handleNotificationNavigation(RemoteMessage message) {
    final data = message.data;
    _navigateBasedOnType(data);
  }

  static void _handleNotificationNavigationFromPayload(String payload) {
    try {
      final data = jsonDecode(payload);
      _navigateBasedOnType(data);
    } catch (e) {
      print('Error parsing notification payload: $e');
    }
  }

  static void _navigateBasedOnType(Map<String, dynamic> data) {
    // TODO: Implement navigation logic berdasarkan NavigatorKey global
    // atau menggunakan routing service yang Anda miliki
    
    if (data['type'] == 'pembelian') {
      print('Navigate to Pembelian: ${data['id_pembelian']}');
      // navigatorKey.currentState?.pushNamed('/pembelian/${data['id_pembelian']}');
    } else if (data['type'] == 'pengiriman') {
      print('Navigate to Pengiriman: ${data['id_pengiriman']}');
      // navigatorKey.currentState?.pushNamed('/pengiriman/${data['id_pengiriman']}');
    } else if (data['type'] == 'donasi') {
      print('Navigate to Donasi: ${data['id_donasi']}');
      // navigatorKey.currentState?.pushNamed('/donasi/${data['id_donasi']}');
    }
  }

  /// Sends FCM token to backend - Called after successful login
  static Future<bool> sendFcmTokenToBackend(String userId) async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null && token.isNotEmpty) {
        print('Sending FCM token to backend for user: $userId');
        await AuthService().sendToken(token, userId);
        
        // Setup token refresh listener
        _setupTokenRefreshListener(userId);
        return true;
      } else {
        print('FCM Token is null or empty');
        return false;
      }
    } catch (e) {
      print('Error sending FCM token: $e');
      return false;
    }
  }

  /// Setup listener for token refresh
  static void _setupTokenRefreshListener(String userId) {
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      print('FCM Token refreshed: $newToken');
      try {
        await AuthService().sendToken(newToken, userId);
        print('Refreshed FCM token sent successfully');
      } catch (e) {
        print('Failed to send refreshed FCM token: $e');
      }
    });
  }

  /// Remove FCM token from backend - Called during logout
  static Future<void> removeFcmTokenFromBackend(String userId) async {
    try {
      await AuthService().removeFcmToken(userId);
      print('FCM token removed from backend for user: $userId');
    } catch (e) {
      print('Error removing FCM token: $e');
    }
  }
}