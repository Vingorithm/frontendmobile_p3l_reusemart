import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bonus_top_seller.dart';
import '../api_service.dart';

class BonusTopSellerService extends BaseApiService {
  Future<List<BonusTopSeller>> getAllBonusTopSeller() async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/bonus-top-seller'), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => BonusTopSeller.fromJson(json)).toList();
      } else {
        print('Failed to load bonus top seller: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load bonus top seller: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching bonus top seller: $e');
      rethrow;
    }
  }

  Future<BonusTopSeller> getBonusTopSellerById(String id) async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/bonus-top-seller/$id'), headers: headers);
      if (response.statusCode == 200) {
        return BonusTopSeller.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('BonusTopSeller not found');
      } else {
        throw Exception('Failed to load bonus top seller: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching bonus top seller by id: $e');
      rethrow;
    }
  }
}