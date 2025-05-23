import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sub_pembelian.dart';
import '../api_service.dart';

class SubPembelianService extends BaseApiService {
  Future<List<SubPembelian>> getAllSubPembelian() async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/sub-pembelian'), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => SubPembelian.fromJson(json)).toList();
      } else {
        print('Failed to load sub pembelian: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load sub pembelian: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching sub pembelian: $e');
      rethrow;
    }
  }

  Future<SubPembelian> getSubPembelianById(String id) async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/sub-pembelian/$id'), headers: headers);
      if (response.statusCode == 200) {
        return SubPembelian.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('SubPembelian not found');
      } else {
        throw Exception('Failed to load sub pembelian: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching sub pembelian by id: $e');
      rethrow;
    }
  }
}