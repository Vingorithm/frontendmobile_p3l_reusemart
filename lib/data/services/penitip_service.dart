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

  Future<Penitip> getPenitipByIdAkun(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${BaseApiService.baseUrl}/penitip/byIdAkun/$id'),
        headers: headers,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Penitip.fromJson(responseData['penitip']);
      } else if (response.statusCode == 404) {
        throw Exception('Penitip tidak ditemukan');
      } else if (response.statusCode == 401) {
        throw Exception('Tidak diizinkan: Token tidak valid');
      } else if (response.statusCode == 403) {
        throw Exception('Akses ditolak');
      } else {
        throw Exception('Gagal memuat data penitip: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching penitip by id akun: $e');
      rethrow;
    }
  }
}