import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pembeli.dart';
import '../api_service.dart';

class PembeliService extends BaseApiService {
  Future<List<Pembeli>> getAllPembeli() async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/pembeli'), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Pembeli.fromJson(json)).toList();
      } else {
        print('Failed to load pembeli: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load pembeli: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pembeli: $e');
      rethrow;
    }
  }

  Future<Pembeli> getPembeliById(String id) async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/pembeli/$id'), headers: headers);
      if (response.statusCode == 200) {
        return Pembeli.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Pembeli not found');
      } else {
        throw Exception('Failed to load pembeli: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pembeli by id: $e');
      rethrow;
    }
  }
}