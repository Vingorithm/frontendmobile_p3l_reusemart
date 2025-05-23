import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/akun.dart';
import '../api_service.dart';

class AkunService extends BaseApiService {
  Future<List<Akun>> getAllAkun() async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/akun'), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Akun.fromJson(json)).toList();
      } else {
        print('Failed to load akun: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load akun: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching akun: $e');
      rethrow;
    }
  }

  Future<Akun> getAkunById(String id) async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/akun/$id'), headers: headers);
      if (response.statusCode == 200) {
        return Akun.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Akun not found');
      } else {
        throw Exception('Failed to load akun: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching akun by id: $e');
      rethrow;
    }
  }
}