import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/request_donasi.dart';
import '../api_service.dart';

class RequestDonasiService extends BaseApiService {
  Future<List<RequestDonasi>> getAllRequestDonasi() async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/request-donasi'), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => RequestDonasi.fromJson(json)).toList();
      } else {
        print('Failed to load request donasi: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load request donasi: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching request donasi: $e');
      rethrow;
    }
  }

  Future<RequestDonasi> getRequestDonasiById(String id) async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/request-donasi/$id'), headers: headers);
      if (response.statusCode == 200) {
        return RequestDonasi.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('RequestDonasi not found');
      } else {
        throw Exception('Failed to load request donasi: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching request donasi by id: $e');
      rethrow;
    }
  }
}