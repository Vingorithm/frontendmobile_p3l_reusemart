import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/barang.dart';
import '../api_service.dart';

class BarangService extends BaseApiService {
  Future<List<Barang>> getAllBarang() async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/barang/mobile'), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Barang.fromJson(json)).toList();
      } else {
        print('Failed to load barang: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load barang: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching barang: $e');
      rethrow;
    }
  }

  Future<Barang> getBarangById(String id) async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/barang/mobile/$id'), headers: headers);
      if (response.statusCode == 200) {
        return Barang.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Barang not found');
      } else {
        throw Exception('Failed to load barang: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching barang by id: $e');
      rethrow;
    }
  }
}