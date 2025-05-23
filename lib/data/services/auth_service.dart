import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/akun.dart';
import '../api_service.dart';

class AuthService extends BaseApiService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email dan password tidak boleh kosong');
      }

      print('=== LOGIN REQUEST ===');
      print('Email: $email');
      print('URL: ${BaseApiService.baseUrl}/akun/login');

      final response = await http.post(
        Uri.parse('${BaseApiService.baseUrl}/akun/login'),
        headers: headers,
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
        }),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['akun'] == null) {
          print('❌ Response akun data is null');
          throw Exception('Response data tidak valid - akun null');
        }

        if (data['akun']['id_akun'] == null) {
          print('❌ User ID (id_akun) is null in response');
          print('Available keys in akun: ${data['akun'].keys.toList()}');
          throw Exception('Response data tidak valid - id_akun null');
        }

        print('✅ Login successful for user: ${data['akun']['id_akun']}');
        print('User role: ${data['akun']['role']}');
        print('User email: ${data['akun']['email']}');
        
        return data;
      } else if (response.statusCode == 404) {
        final errorData = jsonDecode(response.body);
        throw Exception('Email tidak ditemukan');
      } else if (response.statusCode == 401) {
        final errorData = jsonDecode(response.body);
        throw Exception('Password salah');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Login gagal');
      }
    } on http.ClientException catch (e) {
      print('❌ HTTP Client Error: $e');
      throw Exception('Koneksi gagal: Periksa koneksi internet Anda');
    } on FormatException catch (e) {
      print('❌ JSON Format Error: $e');
      throw Exception('Format response tidak valid dari server');
    } catch (e) {
      print('❌ General Login Error: $e');
      if (e.toString().contains('Email tidak ditemukan') || 
          e.toString().contains('Password salah')) {
        rethrow;
      }
      throw Exception('Terjadi kesalahan saat login: $e');
    }
  }

  Future<bool> sendToken(String token, String userId) async {
    try {
      if (token.isEmpty || userId.isEmpty) {
        print('❌ FCM Token atau User ID kosong');
        throw Exception('Token dan User ID tidak boleh kosong');
      }

      print('=== SENDING FCM TOKEN ===');
      print('User ID: $userId');
      print('Token length: ${token.length}');
      print('Token (first 50 chars): ${token.substring(0, token.length > 50 ? 50 : token.length)}...');
      print('URL: ${BaseApiService.baseUrl}/akun/fcm-token');
      
      final requestBody = {
        'id_akun': userId,
        'fcm_token': token,
      };
      
      print('Request body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse('${BaseApiService.baseUrl}/akun/fcm-token'),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      print('Send token response status: ${response.statusCode}');
      print('Send token response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('FCM token sent successfully');
        print('Response message: ${responseData['message']}');
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        print('Failed to send FCM token');
        print('Error: ${errorData['message']}');
        throw Exception(errorData['message'] ?? 'Failed to send FCM token');
      }
    } on http.ClientException catch (e) {
      print('HTTP Client Error while sending FCM token: $e');
      throw Exception('Koneksi gagal saat mengirim FCM token');
    } on FormatException catch (e) {
      print('JSON Format Error while sending FCM token: $e');
      throw Exception('Response format tidak valid dari server');
    } catch (e) {
      print('General Error sending FCM token: $e');
      rethrow;
    }
  }

  Future<bool> removeFcmToken(String userId) async {
    try {
      if (userId.isEmpty) {
        print('User ID kosong untuk remove FCM token');
        throw Exception('User ID tidak boleh kosong');
      }

      print('=== REMOVING FCM TOKEN ===');
      print('User ID: $userId');
      print('URL: ${BaseApiService.baseUrl}/akun/fcm-token');

      final response = await http.delete(
        Uri.parse('${BaseApiService.baseUrl}/akun/fcm-token'),
        headers: headers,
        body: jsonEncode({'id_akun': userId}),
      );

      print('Remove token response status: ${response.statusCode}');
      print('Remove token response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('FCM token removed successfully');
        print('Response message: ${responseData['message']}');
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        print('Failed to remove FCM token');
        print('Error: ${errorData['message']}');
        throw Exception(errorData['message'] ?? 'Failed to remove FCM token');
      }
    } on http.ClientException catch (e) {
      print('HTTP Client Error while removing FCM token: $e');
      throw Exception('Koneksi gagal saat menghapus FCM token');
    } catch (e) {
      print('General Error removing FCM token: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(
    String role,
    String username,
    String email,
    String password,
    {String? alamat}
  ) async {
    try {
      final Map<String, dynamic> body = {
        'role': role,
        'username': username,
        'email': email,
        'password': password,
      };

      if (role == 'Organisasi Amal' && alamat != null && alamat.isNotEmpty) {
        body['alamat'] = alamat;
      }

      final response = await http.post(
        Uri.parse('${BaseApiService.baseUrl}/akun/register'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);

        print('Registrasi berhasil: ${data['message']}');
        print('ID Akun: ${data['akun']['id_akun']}');
        print('Role: ${data['akun']['role']}');

        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Registrasi gagal');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat registrasi: $e');
    }
  }
}