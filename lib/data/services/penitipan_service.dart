import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/penitipan.dart';
import '../api_service.dart';

class PenitipanService extends BaseApiService {
  Future<List<Penitipan>> getAllPenitipan() async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/penitipan'), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Penitipan.fromJson(json)).toList();
      } else {
        print('Failed to load penitipan: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load penitipan: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching penitipan: $e');
      rethrow;
    }
  }

  Future<Penitipan> getPenitipanById(String id) async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/penitipan/$id'), headers: headers);
      if (response.statusCode == 200) {
        return Penitipan.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Penitipan not found');
      } else {
        throw Exception('Failed to load penitipan: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching penitipan by id: $e');
      rethrow;
    }
  }
}