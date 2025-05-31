import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/penitipan.dart';
import '../api_service.dart';

class PenitipanService extends BaseApiService {
  Future<List<Penitipan>> getAllPenitipan() async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/penitipan'), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Penitipan.fromJson(json)).toList();
      } else {
        print('Failed to load penitipan: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load penitipan: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching penitipan: $e');
      rethrow;
    }
  }

  Future<Penitipan> getPenitipanById(String id) async {
    try {
      final response = await http.get(Uri.parse('${BaseApiService.baseUrl}/penitipan/$id'), headers: headers);
      if (response.statusCode == 200) {
        return Penitipan.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Penitipan not found');
      } else {
        throw Exception('Failed to load penitipan: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching penitipan by id: $e');
      rethrow;
    }
  }

  Future<List<PenitipanWithDetails>> getPenitipanByIdPenitip(String idPenitip) async {
    try {
      final response = await http.get(
        Uri.parse('${BaseApiService.baseUrl}/penitipan/byIdPenitip/$idPenitip'), 
        headers: headers
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => PenitipanWithDetails.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('Penitipan tidak ditemukan untuk penitip ini');
      } else {
        throw Exception('Failed to load penitipan: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching penitipan by penitip id: $e');
      rethrow;
    }
  }
}

// Model classes for detailed penitipan data
class PenitipanWithDetails {
  final Penitipan penitipan;
  final BarangDetail? barang;

  PenitipanWithDetails({
    required this.penitipan,
    this.barang,
  });

  factory PenitipanWithDetails.fromJson(Map<String, dynamic> json) {
    return PenitipanWithDetails(
      penitipan: Penitipan(
        idPenitipan: json['id_penitipan'] ?? '',
        idBarang: json['id_barang'] ?? '',
        tanggalAwalPenitipan: DateTime.parse(json['tanggal_awal_penitipan']),
        tanggalAkhirPenitipan: DateTime.parse(json['tanggal_akhir_penitipan']),
        tanggalBatasPengambilan: DateTime.parse(json['tanggal_batas_pengambilan']),
        perpanjangan: json['perpanjangan'] ?? false,
        statusPenitipan: json['status_penitipan'] ?? '',
      ),
      barang: json['Barang'] != null ? BarangDetail.fromJson(json['Barang']) : null,
    );
  }
}

class BarangDetail {
  final String idBarang;
  final String nama;
  final String gambar;
  final double harga;
  final String kategoriBarang;

  BarangDetail({
    required this.idBarang,
    required this.nama,
    required this.gambar,
    required this.harga,
    required this.kategoriBarang,
  });

  factory BarangDetail.fromJson(Map<String, dynamic> json) {
    return BarangDetail(
      idBarang: json['id_barang'] ?? '',
      nama: json['nama'] ?? '',
      gambar: json['gambar'] ?? '',
      harga: double.tryParse(json['harga'].toString()) ?? 0.0,
      kategoriBarang: json['kategori_barang'] ?? '',
    );
  }
}