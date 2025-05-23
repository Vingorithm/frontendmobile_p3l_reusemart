import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/donasi_barang.dart';
import '../api_service.dart';

class DonasiBarangService extends BaseApiService {
  Future<List<DonasiBarang>> getAllDonasiBarang() async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/donasi-barang'), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => DonasiBarang.fromJson(json)).toList();
      } else {
        print('Failed to load donasi barang: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load donasi barang: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching donasi barang: $e');
      rethrow;
    }
  }

  Future<DonasiBarang> getDonasiBarangById(String id) async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/donasi-barang/$id'), headers: headers);
      if (response.statusCode == 200) {
        return DonasiBarang.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('DonasiBarang not found');
      } else {
        throw Exception('Failed to load donasi barang: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching donasi barang by id: $e');
      rethrow;
    }
  }
}