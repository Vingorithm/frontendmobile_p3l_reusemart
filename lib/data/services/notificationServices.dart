import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:frontendmobile_p3l_reusemart/data/api_service.dart';

class Notificationservices extends BaseApiService {
  Future<Map<String, dynamic>> sendPushNotification(
      String? title, String? body, String? fcmToken) async {
    try {
      if(title == null || body == null || fcmToken == null) {
        throw Exception('Send Notification gagal');
      } else {
        if(title.isEmpty || body.isEmpty || fcmToken.isEmpty) {
          throw Exception('Send Notification gagal');
        } else {
          final response = await http.post(
            Uri.parse(
                '${BaseApiService.baseUrl}/notification/sendPushNotification'),
            headers: headers,
            body: jsonEncode({
              "fcmToken": fcmToken,
              "title": title,
              "body": body,
            }),
          );

          print('Send Notification response status: ${response.statusCode}');
          print('Send Notification response body: ${response.body}');

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            return data;
          } else {
            final errorData = jsonDecode(response.body);
            throw Exception(errorData['message'] ?? 'Send Notification gagal');
          }
        }
      }
    } catch (e) {
      print("Failed send push notification!");
      throw Exception("Gagal mengirim notifikasi!");
    }
  }
}
