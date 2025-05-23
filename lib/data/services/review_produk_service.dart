import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/review_produk.dart';
import '../api_service.dart';

class ReviewProdukService extends BaseApiService {
  Future<List<ReviewProduk>> getAllReviewProduk() async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/review-produk'), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ReviewProduk.fromJson(json)).toList();
      } else {
        print('Failed to load review produk: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load review produk: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching review produk: $e');
      rethrow;
    }
  }

  Future<ReviewProduk> getReviewProdukById(String id) async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/review-produk/$id'), headers: headers);
      if (response.statusCode == 200) {
        return ReviewProduk.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('ReviewProduk not found');
      } else {
        throw Exception('Failed to load review produk: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching review produk by id: $e');
      rethrow;
    }
  }
}