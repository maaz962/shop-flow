import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel =
  AndroidNotificationChannel(
    'shopflow_notifications',
    'ShopFlow Notifications',
    description: 'Notifications for ShopFlow',
    importance: Importance.high,
  );

  Future<void> initialize() async {
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

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(
            (RemoteMessage message) {
          print('FOREGROUND MESSAGE RECEIVED');

          final notification = message.notification;

          if (notification != null) {
            _showLocalNotification(
              title: notification.title ?? 'ShopFlow',
              body: notification.body ?? '',
            );
          }
        },
      );
    } catch (e) {
      print('FCM ERROR: $e');
    }
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