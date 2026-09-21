import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

class NotificationSenderService {
  static const _projectId = 'testing-cli-ab36b';
  static const _scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  Future<void> sendNotification({
    required String toToken,
    required String title,
    required String body,
    Map<String, String>? data,
}) async {
    try {
      final client = await _getAuthClient();

      final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send',
      );

      final payload = {
        'message' : {
          'token' : toToken,
          'notification' : {
            'title' : title,
            'body' : body,
          },
          if(data != null) 'data':data,
        },
      };

      final response = await client.post(
        url,
        headers: {'Content-Type' : 'application/json' },
        body: jsonEncode(payload),
      );

      if(response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('FCM send failed: ${response.statusCode} - ${response.body}');

      }
      client.close();
    } catch (e) {
      print('NotificationSenderService ERROR: $e');
    }
  }

  Future<auth.AuthClient> _getAuthClient() async {
    final jsonString =
    await rootBundle.loadString('assets/service_account.json');
    final credentials =
    auth.ServiceAccountCredentials.fromJson(jsonString);

    return await auth.clientViaServiceAccount(credentials, _scopes);
  }
}





















// notification_sender_service.dart
// → doosre device ko notification SEND karega
//
// notification_receiver_service.dart
// → FCM notification RECEIVE karega
// → local notification show karega
// → foreground/background/terminated handling