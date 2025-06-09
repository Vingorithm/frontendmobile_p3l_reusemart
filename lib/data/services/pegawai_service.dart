import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pegawai.dart';
import '../api_service.dart';

class PegawaiService extends BaseApiService {
  Future<List<Pegawai>> getAllPegawai() async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/pegawai'), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Pegawai.fromJson(json)).toList();
      } else {
        print('Failed to load pegawai: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load pegawai: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pegawai: $e');
      rethrow;
    }
  }

  Future<Pegawai> getPegawaiById(String id) async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/pegawai/$id'), headers: headers);
      if (response.statusCode == 200) {
        return Pegawai.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Pegawai not found');
      } else {
        throw Exception('Failed to load pegawai: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pegawai by id: $e');
      rethrow;
    }
  }

  Future<Pegawai> getPegawaiByIdAkun(String id) async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/pegawai/byIdAkun/$id'), headers: headers);
      if (response.statusCode == 200) {
        return Pegawai.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Pegawai not found');
      } else {
        throw Exception('Failed to load pegawai: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pegawai by id akun: $e');
      rethrow;
    }
  }
}