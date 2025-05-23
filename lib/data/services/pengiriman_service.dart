import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pengiriman.dart';
import '../api_service.dart';

class PengirimanService extends BaseApiService {
  Future<List<Pengiriman>> getAllPengiriman() async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/pengiriman'), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Pengiriman.fromJson(json)).toList();
      } else {
        print('Failed to load pengiriman: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load pengiriman: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pengiriman: $e');
      rethrow;
    }
  }

  Future<Pengiriman> getPengirimanById(String id) async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/pengiriman/$id'), headers: headers);
      if (response.statusCode == 200) {
        return Pengiriman.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Pengiriman not found');
      } else {
        throw Exception('Failed to load pengiriman: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pengiriman by id: $e');
      rethrow;
    }
  }
}