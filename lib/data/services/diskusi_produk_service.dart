import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/diskusi_produk.dart';
import '../api_service.dart';

class DiskusiProdukService extends BaseApiService {
  Future<List<DiskusiProduk>> getAllDiskusiProduk() async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/diskusi-produk'), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => DiskusiProduk.fromJson(json)).toList();
      } else {
        print('Failed to load diskusi produk: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load diskusi produk: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching diskusi produk: $e');
      rethrow;
    }
  }

  Future<DiskusiProduk> getDiskusiProdukById(String id) async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/diskusi-produk/$id'), headers: headers);
      if (response.statusCode == 200) {
        return DiskusiProduk.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('DiskusiProduk not found');
      } else {
        throw Exception('Failed to load diskusi produk: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching diskusi produk by id: $e');
      rethrow;
    }
  }
}