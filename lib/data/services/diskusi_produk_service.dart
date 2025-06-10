import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/diskusi_produk.dart';
import '../api_service.dart';

class DiskusiProdukService extends BaseApiService {
  Future<List<DiskusiProduk>> getAllDiskusiProduk() async {
    try {
      final response = await http.get(
          Uri.parse('${BaseApiService.baseUrl}/diskusi-produk'),
          headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => DiskusiProduk.fromJson(json)).toList();
      } else {
        print(
            'Failed to load diskusi produk: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Failed to load diskusi produk: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching diskusi produk: $e');
      rethrow;
    }
  }

  Future<List<DiskusiProduk>> getDiskusiByIdBarang(String idBarang) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${BaseApiService.baseUrl}/diskusi-produk/byIdBarang/$idBarang'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => DiskusiProduk.fromJson(json)).toList();
      } else {
        print(
            'Failed to load diskusi by barang: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Failed to load diskusi by barang: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching diskusi by barang: $e');
      rethrow;
    }
  }
}
