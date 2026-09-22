import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../app/routes/app_routes.dart';
import '../services/user_service.dart';
import 'package:flutter/foundation.dart';

class NotificationReceiverService {
  final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  final UserService _userService = UserService();

  static const AndroidNotificationChannel _channel =
  AndroidNotificationChannel(
    'shopflow_notifications',
    'ShopFlow Notifications',
    description: 'Notifications for ShopFlow',
    importance: Importance.high,
  );

  Future<void> initialize() async {
    if (kIsWeb) {
      print('FCM disabled on Web.');
      return;
    }

    try {
      // Ask user for notification permission
      final settings = await _firebaseMessaging.requestPermission();

      print(
        'Notification permission: '
            '${settings.authorizationStatus}',
      );

      // Initialize local notifications
      const androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      const initializationSettings = InitializationSettings(
        android: androidSettings,
      );

      await _localNotifications.initialize(
        settings: initializationSettings,
      );

      // Create Android notification channel
      await _localNotifications
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);

      // Get FCM token
      final token = await _firebaseMessaging.getToken();
      print('FCM TOKEN: $token');
      await _saveTokenIfLoggedIn(token);

      _firebaseMessaging.onTokenRefresh.listen((newToken) async {
        print('FCM TOKEN REFRESHED: $newToken');
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(
            (RemoteMessage message) {
          // print('FOREGROUND MESSAGE RECEIVED');

          final notification = message.notification;

          if (notification != null) {
            _showLocalNotification(
              title: notification.title ?? 'ShopFlow',
              body: notification.body ?? '',
            );
          }
        },
      );

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
        print('Notification tapped (background): ${message.data}');
        _handleNotificationTap(message);
        // yahan navigation logic daal sakte ho, e.g. order id se order screen
      });

      // 👇 ADD — app terminated thi aur notification tap se khuli
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        print('Notification tapped (terminated): ${initialMessage.data}');
        Future.delayed(const Duration(milliseconds: 2300), () {
          _handleNotificationTap(initialMessage);
        });
        // navigation logic
      }
    } catch (e) {
      print('FCM ERROR: $e');
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    final type = message.data['type'];
    if(type == 'order') {
      Get.toNamed(AppRoutes.orders);
    }
  }

  // 👇 ADD — token ko current logged-in user se link karo
  Future<void> _saveTokenIfLoggedIn(String? token) async {
    if (token == null) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return; // abhi login nahi hai, baad mein save hoga
    await _userService.updateFcmToken(uid: uid, token: token);
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'shopflow_notifications',
      'ShopFlow Notifications',
      channelDescription: 'Notifications for ShopFlow',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    final int notificationId =
    DateTime.now().millisecondsSinceEpoch.remainder(100000);

    await _localNotifications.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }
}