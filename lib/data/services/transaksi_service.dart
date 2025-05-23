import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaksi.dart';
import '../api_service.dart';

class TransaksiService extends BaseApiService {
  Future<List<Transaksi>> getAllTransaksi() async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/transaksi'), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Transaksi.fromJson(json)).toList();
      } else {
        print('Failed to load transaksi: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load transaksi: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching transaksi: $e');
      rethrow;
    }
  }

  Future<Transaksi> getTransaksiById(String id) async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/transaksi/$id'), headers: headers);
      if (response.statusCode == 200) {
        return Transaksi.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Transaksi not found');
      } else {
        throw Exception('Failed to load transaksi: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching transaksi by id: $e');
      rethrow;
    }
  }
}