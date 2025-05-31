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
        headers: headers,
      );
      
      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        print('Total data received: ${data.length}');
        
        List<Barang> barangList = [];
        int errorCount = 0;
        
        for (int i = 0; i < data.length; i++) {
          try {
            final itemData = data[i];       
            final barang = Barang.fromJson(itemData);
            barangList.add(barang);
          } catch (e, stackTrace) {
            errorCount++;
            final itemData = data[i];
            ['harga', 'berat', 'garansi_berlaku', 'tanggal_garansi'].forEach((field) {
              final value = itemData[field];
              print('  - $field: $value (${value.runtimeType})');
            });
            
            continue;
          }
        }
        
        print('✅ Successfully parsed ${barangList.length} out of ${data.length} items');
        if (errorCount > 0) {
          print('❌ Failed to parse $errorCount items');
        }
        
        return barangList;
      } else {
        print('Failed to load barang: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load barang: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error fetching barang: $e');
      print('Stack trace: $stackTrace');
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
      
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return Barang.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        throw Exception('Barang not found');
      } else {
        throw Exception('Failed to load barang: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error fetching barang by id: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}