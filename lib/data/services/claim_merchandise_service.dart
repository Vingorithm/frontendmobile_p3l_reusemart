import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/claim_merchandise.dart';
import '../api_service.dart';

class ClaimMerchandiseService extends BaseApiService {
  Future<List<ClaimMerchandise>> getAllClaimMerchandise() async {
    try {
      final response = await http.get(
          Uri.parse('${BaseApiService.baseUrl}/claim-merchandise'),
          headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ClaimMerchandise.fromJson(json)).toList();
      } else {
        print(
            'Failed to load claim merchandise: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Failed to load claim merchandise: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching claim merchandise: $e');
      rethrow;
    }
  }

  Future<ClaimMerchandise> getClaimMerchandiseById(String id) async {
    try {
      final response = await http.get(
          Uri.parse('${BaseApiService.baseUrl}/claim-merchandise/$id'),
          headers: headers);
      if (response.statusCode == 200) {
        return ClaimMerchandise.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Claim Merchandise not found');
      } else {
        throw Exception(
            'Failed to load claim merchandise: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching claim merchandise by id: $e');
      rethrow;
    }
  }

  Future<List<ClaimMerchandise>> getClaimMerchandiseByIdPembeli(
      String id) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${BaseApiService.baseUrl}/claim-merchandise/byIdPembeli/$id'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ClaimMerchandise.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        return []; // Return empty list if no claims found
      } else {
        throw Exception(
            'Failed to load claim merchandise: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching claim merchandise by id: $e');
      rethrow;
    }
  }

  Future<ClaimMerchandise> createClaimMerchandise({
    required String idMerchandise,
    required String idPembeli,
    String? idCustomerService,
    required String tanggalClaim,
    String? tanggalAmbil,
    String statusClaimMerchandise = 'Pending',
  }) async {
    try {
      final body = {
        'id_merchandise': idMerchandise,
        'id_pembeli': idPembeli,
        'id_customer_service': idCustomerService,
        'tanggal_claim': tanggalClaim,
        'tanggal_ambil': tanggalAmbil,
        'status_claim_merchandise': statusClaimMerchandise,
      };

      final response = await http.post(
        Uri.parse('${BaseApiService.baseUrl}/claim-merchandise'),
        headers: {
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(body), // Encode ke JSON string
      );

      if (response.statusCode == 201) {
        return ClaimMerchandise.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create claim: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating claim merchandise: $e');
      rethrow;
    }
  }
}
