// lib/data/services/pembeli_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pembeli.dart';
import '../api_service.dart';

class PembeliService extends BaseApiService {
  Future<List<Pembeli>> getAllPembeli() async {
    try {
      final response = await http.get(
          Uri.parse('${BaseApiService.baseUrl}/pembeli'),
          headers: headers);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // For debugging

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data =
            responseData['pembeli'] ?? []; // Extract 'pembeli' key
        return data.map((json) => Pembeli.fromJson(json)).toList();
      } else {
        print(
            'Failed to load pembeli: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load pembeli: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pembeli: $e');
      rethrow;
    }
  }

  Future<Pembeli> getPembeliById(String id) async {
    try {
      final response = await http.get(
          Uri.parse('${BaseApiService.baseUrl}/pembeli/$id'),
          headers: headers);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // For debugging

      if (response.statusCode == 200) {
        return Pembeli.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Pembeli not found');
      } else {
        throw Exception('Failed to load pembeli: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pembeli by id: $e');
      rethrow;
    }
  }

  Future<Pembeli> getPembeliByIdAkun(String idAkun) async {
    try {
      final response = await http.get(
        Uri.parse('${BaseApiService.baseUrl}/pembeli/byIdAkun/$idAkun'),
        headers: headers,
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey('pembeli')) {
          final Map<String, dynamic> pembeliData = responseData['pembeli'];
          return Pembeli.fromJson(pembeliData);
        } else {
          return Pembeli.fromJson(responseData);
        }
      } else if (response.statusCode == 404) {
        throw Exception('Pembeli not found for this account');
      } else {
        throw Exception('Failed to load pembeli: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pembeli by id_akun: $e');
      rethrow;
    }
  }

  Future<Pembeli> updatePoinPembeli(String idPembeli, int newTotalPoin) async {
    try {
      final response = await http.put(
        Uri.parse('${BaseApiService.baseUrl}/pembeli/$idPembeli/poin'),
        headers: {
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode({
          'total_poin': newTotalPoin,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Pembeli.fromJson(responseData['pembeli']);
      } else {
        throw Exception('Failed to update poin: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating poin pembeli: $e');
      rethrow;
    }
  }
}
