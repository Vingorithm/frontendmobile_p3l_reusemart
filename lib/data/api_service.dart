import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/barang_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  Future<List<Barang>> getAllBarang() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/barang'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Barang.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      return _getMockBarang();
    }
  }

  List<Barang> _getMockBarang() {
    return [
      Barang(
        idBarang: 'L1',
        nama: 'Laptop Gaming',
        deskripsi: 'Laptop gaming dengan spesifikasi tinggi',
        gambar: 'https://via.placeholder.com/400x300',
        harga: 15000000,
        kategoriBarang: 'Elektronik',
        berat: 2.5,
        statusQc: 'Lulus',
        garansiBerlaku: true,
      ),
      Barang(
        idBarang: 'S1',
        nama: 'Smartphone XYZ',
        deskripsi: 'Smartphone terbaru dengan kamera 108MP',
        gambar: 'https://via.placeholder.com/400x300',
        harga: 8000000,
        kategoriBarang: 'Elektronik',
        berat: 0.2,
        statusQc: 'Lulus',
        garansiBerlaku: true,
      ),
      Barang(
        idBarang: 'K1',
        nama: 'Kamera DSLR',
        deskripsi: 'Kamera DSLR profesional',
        gambar: 'https://via.placeholder.com/400x300',
        harga: 12000000,
        kategoriBarang: 'Elektronik',
        berat: 1.2,
        statusQc: 'Lulus',
        garansiBerlaku: true,
      ),
      Barang(
        idBarang: 'J1',
        nama: 'Jam Tangan Pintar',
        deskripsi: 'Jam tangan pintar dengan berbagai fitur',
        gambar: 'https://via.placeholder.com/400x300',
        harga: 3000000,
        kategoriBarang: 'Aksesoris',
        berat: 0.1,
        statusQc: 'Lulus',
        garansiBerlaku: true,
      ),
    ];
  }
}