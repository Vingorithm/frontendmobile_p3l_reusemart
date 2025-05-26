// lib/data/services/barang_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/barang.dart';
import '../api_service.dart';

class BarangService extends BaseApiService {
  Future<List<Barang>> getAllBarang() async {
    try {
      final response = await http.get(
        Uri.parse('${BaseApiService.baseUrl}/barang/mobile'), 
        headers: headers
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Total data received: ${data.length}');
        
        List<Barang> barangList = [];
        
        for (int i = 0; i < data.length; i++) {
          try {
            print('Processing item $i: ${data[i]}');
            final barang = Barang.fromJson(data[i]);
            barangList.add(barang);
            print('Successfully parsed item $i: ${barang.nama}');
          } catch (e) {
            print('Error parsing item $i: $e');
            print('Item data: ${data[i]}');
            // Skip item yang error dan lanjutkan dengan item berikutnya
            continue;
          }
        }
        
        print('Successfully parsed ${barangList.length} out of ${data.length} items');
        return barangList;
        
      } else {
        print('Failed to load barang: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load barang: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching barang: $e');
      rethrow;
    }
  }

  Future<Barang> getBarangById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${BaseApiService.baseUrl}/barang/mobile/$id'), 
        headers: headers
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return Barang.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        throw Exception('Barang not found');
      } else {
        throw Exception('Failed to load barang: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching barang by id: $e');
      rethrow;
    }
  }
}