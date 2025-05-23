import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/organisasi_amal.dart';
import '../api_service.dart';

class OrganisasiAmalService extends BaseApiService {
  Future<List<OrganisasiAmal>> getAllOrganisasiAmal() async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/organisasi-amal'), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => OrganisasiAmal.fromJson(json)).toList();
      } else {
        print('Failed to load organisasi amal: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load organisasi amal: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching organisasi amal: $e');
      rethrow;
    }
  }

  Future<OrganisasiAmal> getOrganisasiAmalById(String id) async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/organisasi-amal/$id'), headers: headers);
      if (response.statusCode == 200) {
        return OrganisasiAmal.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('OrganisasiAmal not found');
      } else {
        throw Exception('Failed to load organisasi amal: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching organisasi amal by id: $e');
      rethrow;
    }
  }
}