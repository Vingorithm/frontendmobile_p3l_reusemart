import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/keranjang.dart';
import '../api_service.dart';

class KeranjangService extends BaseApiService {
  Future<List<Keranjang>> getAllKeranjang() async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/keranjang'), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Keranjang.fromJson(json)).toList();
      } else {
        print('Failed to load keranjang: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load keranjang: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching keranjang: $e');
      rethrow;
    }
  }

  Future<Keranjang> getKeranjangById(String id) async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/keranjang/$id'), headers: headers);
      if (response.statusCode == 200) {
        return Keranjang.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Keranjang not found');
      } else {
        throw Exception('Failed to load keranjang: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching keranjang by id: $e');
      rethrow;
    }
  }
}