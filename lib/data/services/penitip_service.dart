import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/penitip.dart';
import '../api_service.dart';

class PenitipService extends BaseApiService {
  Future<List<Penitip>> getAllPenitip() async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/penitip'), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Penitip.fromJson(json)).toList();
      } else {
        print('Failed to load penitip: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load penitip: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching penitip: $e');
      rethrow;
    }
  }

  Future<Penitip> getPenitipById(String id) async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/penitip/$id'), headers: headers);
      if (response.statusCode == 200) {
        return Penitip.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Penitip not found');
      } else {
        throw Exception('Failed to load penitip: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching penitip by id: $e');
      rethrow;
    }
  }
}