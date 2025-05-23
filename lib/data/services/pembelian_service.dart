import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pembelian.dart';
import '../api_service.dart';

class PembelianService extends BaseApiService {
  Future<List<Pembelian>> getAllPembelian() async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/pembelian'), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Pembelian.fromJson(json)).toList();
      } else {
        print('Failed to load pembelian: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load pembelian: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pembelian: $e');
      rethrow;
    }
  }

  Future<Pembelian> getPembelianById(String id) async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/pembelian/$id'), headers: headers);
      if (response.statusCode == 200) {
        return Pembelian.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Pembelian not found');
      } else {
        throw Exception('Failed to load pembelian: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pembelian by id: $e');
      rethrow;
    }
  }
}