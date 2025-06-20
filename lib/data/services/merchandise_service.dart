import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/merchandise.dart';
import '../api_service.dart';

class MerchandiseService extends BaseApiService {
  Future<List<Merchandise>> getAllMerchandise() async {
    try {
      final response = await http.get(
          Uri.parse('${BaseApiService.baseUrl}/merchandise'),
          headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Merchandise.fromJson(json)).toList();
      } else {
        print(
            'Failed to load merchandise: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load merchandise: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching merchandise: $e');
      rethrow;
    }
  }

  Future<Merchandise> getMerchandiseById(String id) async {
    try {
      final response = await http.get(
          Uri.parse('${BaseApiService.baseUrl}/merchandise/mobile/$id'),
          headers: headers);
      if (response.statusCode == 200) {
        return Merchandise.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Merchandise not found');
      } else {
        throw Exception('Failed to load merchandise: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching merchandise by id: $e');
      rethrow;
    }
  }

  Future<List<Merchandise>> getAllMobileMerchandise() async {
    try {
      final response = await http.get(
          Uri.parse('${BaseApiService.baseUrl}/merchandise/mobile'),
          headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Merchandise.fromJson(json)).toList();
      } else {
        print(
            'Failed to load merchandise: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load merchandise: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching merchandise: $e');
      rethrow;
    }
  }

  Future<Merchandise> updateStokMerchandise(
      String idMerchandise, int newStok) async {
    try {
      final response = await http.put(
        Uri.parse('${BaseApiService.baseUrl}/merchandise/$idMerchandise/stok'),
        headers: {
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode({
          'stok_merchandise': newStok,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Merchandise.fromJson(responseData['merchandise']);
      } else {
        throw Exception('Failed to update stok: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating stok merchandise: $e');
      rethrow;
    }
  }
}
