import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/alamat_pembeli.dart';
import '../api_service.dart';

class AlamatPembeliService extends BaseApiService {
  Future<List<AlamatPembeli>> getAllAlamatPembeli() async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/alamat-pembeli'), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => AlamatPembeli.fromJson(json)).toList();
      } else {
        print('Failed to load alamat pembeli: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load alamat pembeli: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching alamat pembeli: $e');
      rethrow;
    }
  }

  Future<AlamatPembeli> getAlamatPembeliById(String id) async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/alamat-pembeli/$id'), headers: headers);
      if (response.statusCode == 200) {
        return AlamatPembeli.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('AlamatPembeli not found');
      } else {
        throw Exception('Failed to load alamat pembeli: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching alamat pembeli by id: $e');
      rethrow;
    }
  }
}