// lib/services/notification_service.dart - PERBAIKAN LENGKAP
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../data/services/auth_service.dart';
import '../firebase_options.dart';
import 'dart:convert';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  // TAMBAHKAN: Global Navigator Key untuk navigasi
  static GlobalKey<NavigatorState>? navigatorKey;
  
  static void setNavigatorKey(GlobalKey<NavigatorState> key) {
    navigatorKey = key;
  }

  /// Initialize Notification dengan Channel yang konsisten
  static Future<void> initializeNotification() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // Request permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      print('User denied notification permissions');
      return;
    }

    // PERBAIKAN: Setup notification channel yang konsisten dengan backend
    await _createNotificationChannel();
    
    // Initialize local notifications
    await _initializeLocalNotification();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("📱 Foreground message received: ${message.messageId}");
      await _showFlutterNotification(message);
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Handle app opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📱 App opened from notification: ${message.data}");
      _handleNotificationNavigation(message.data);
    });

    // Handle app launched from terminated state
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print("📱 App launched from notification: ${initialMessage.data}");
      Future.delayed(const Duration(seconds: 3), () {
        _handleNotificationNavigation(initialMessage.data);
      });
    }

    // Get FCM token
    String? token = await _firebaseMessaging.getToken();
    print('🔑 FCM Token: ${token?.substring(0, 20)}...');
  }

  /// TAMBAHKAN: Create Notification Channel
  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'reusemart_channel', // SAMA dengan backend
      'ReuseMart Notifications',
      description: 'Notifications for ReuseMart app',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Background message handler
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    print("📱 Background message: ${message.messageId}");
    await _initializeLocalNotification();
    await _showFlutterNotification(message);
  }

  /// PERBAIKAN: Show notification dengan channel yang benar
  static Future<void> _showFlutterNotification(RemoteMessage message) async {
    String title = message.notification?.title ?? message.data['title'] ?? 'Notifikasi Baru';
    String body = message.notification?.body ?? message.data['body'] ?? 'Pesan baru';

    // PERBAIKAN: Gunakan channel ID yang sama dengan backend
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'reusemart_channel', // KONSISTEN dengan backend
      'ReuseMart Notifications',
      channelDescription: 'Notifications for ReuseMart app',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      icon: '@drawable/ic_launcher',
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
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        notificationDetails,
        payload: jsonEncode(message.data),
      );
      print("✅ Notification displayed successfully");
    } catch (e) {
      print('❌ Error showing notification: $e');
    }
  }

  /// Initialize local notification
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
          try {
            final data = jsonDecode(response.payload!);
            _handleNotificationNavigation(data);
          } catch (e) {
            print('❌ Error parsing payload: $e');
          }
        }
      },
    );
  }

  /// PERBAIKAN: Implementasi navigasi yang lengkap
  static void _handleNotificationNavigation(Map<String, dynamic> data) {
    if (navigatorKey?.currentState == null) {
      print('⚠️ Navigator not available');
      return;
    }

    final context = navigatorKey!.currentState!.context;
    
    switch (data['type']) {
      case 'penitipan_expired':
        _navigateToPenitipanDetail(context, data);
        break;
      case 'pembelian':
        _navigateToPembelianDetail(context, data);
        break;
      case 'pengiriman':
        _navigateToPengirimanDetail(context, data);
        break;
      case 'donasi':
        _navigateToDonasiDetail(context, data);
        break;
      default:
        print('🤷 Unknown notification type: ${data['type']}');
    }
  }

  static void _navigateToPenitipanDetail(BuildContext context, Map<String, dynamic> data) {
    // IMPLEMENTASI: Navigasi ke halaman detail penitipan
    print('🏠 Navigate to penitipan: ${data['id_penitipan']}');
    
    // Contoh navigasi (sesuaikan dengan routing Anda):
    Navigator.of(context).pushNamed(
      '/penitipan/detail',
      arguments: {
        'id_penitipan': data['id_penitipan'],
        'id_barang': data['id_barang'],
        'fromNotification': true,
      }
    );
  }

  static void _navigateToPembelianDetail(BuildContext context, Map<String, dynamic> data) {
    Navigator.of(context).pushNamed('/pembelian/detail', arguments: data);
  }

  static void _navigateToPengirimanDetail(BuildContext context, Map<String, dynamic> data) {
    Navigator.of(context).pushNamed('/pengiriman/detail', arguments: data);
  }

  static void _navigateToDonasiDetail(BuildContext context, Map<String, dynamic> data) {
    Navigator.of(context).pushNamed('/donasi/detail', arguments: data);
  }

  /// Send FCM token to backend
  static Future<bool> sendFcmTokenToBackend(String userId) async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null && token.isNotEmpty) {
        print('📤 Sending FCM token for user: $userId');
        await AuthService().sendToken(token, userId);
        _setupTokenRefreshListener(userId);
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Error sending FCM token: $e');
      return false;
    }
  }

  /// Setup token refresh listener
  static void _setupTokenRefreshListener(String userId) {
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      print('🔄 FCM Token refreshed');
      try {
        await AuthService().sendToken(newToken, userId);
      } catch (e) {
        print('❌ Failed to send refreshed token: $e');
      }
    });
  }

  /// Remove FCM token
  static Future<void> removeFcmTokenFromBackend(String userId) async {
    try {
      await AuthService().removeFcmToken(userId);
      print('🗑️ FCM token removed for user: $userId');
    } catch (e) {
      print('❌ Error removing FCM token: $e');
    }
  }
}