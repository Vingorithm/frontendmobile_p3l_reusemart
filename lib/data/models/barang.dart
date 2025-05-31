// lib/data/models/barang.dart
import 'package:json_annotation/json_annotation.dart';
import 'penitip.dart';
import 'pegawai.dart';

part 'barang.g.dart';

@JsonSerializable(explicitToJson: true)
class Barang {
  @JsonKey(name: 'id_barang')
  final String idBarang;
  
  @JsonKey(name: 'id_penitip')
  final String idPenitip;
  
  @JsonKey(name: 'id_hunter')
  final String? idHunter;
  
  @JsonKey(name: 'id_pegawai_gudang')
  final String idPegawaiGudang;
  
  final String nama;
  final String deskripsi;
  final String gambar;
  
  @JsonKey(fromJson: _stringToDouble)
  final double harga;
  
  @JsonKey(name: 'garansi_berlaku')
  final bool garansiBerlaku;
  
  @JsonKey(name: 'tanggal_garansi', fromJson: _stringToDateTime)
  final DateTime? tanggalGaransi;

  @JsonKey(fromJson: _stringToDouble)
  final double berat;
  
  @JsonKey(name: 'status_qc')
  final String statusQc;
  
  @JsonKey(name: 'kategori_barang')
  final String kategoriBarang;
  
  @JsonKey(name: 'Penitip')
  final Penitip? penitip;
  
  @JsonKey(name: 'Hunter')
  final Pegawai? hunter;
  
  @JsonKey(name: 'PegawaiGudang')
  final Pegawai? pegawaiGudang;
  
  Barang({
    required this.idBarang,
    required this.idPenitip,
    this.idHunter,
    required this.idPegawaiGudang,
    required this.nama,
    required this.deskripsi,
    required this.gambar,
    required this.harga,
    required this.garansiBerlaku,
    this.tanggalGaransi,
    required this.berat,
    required this.statusQc,
    required this.kategoriBarang,
    this.penitip,
    this.hunter,
    this.pegawaiGudang,
  });
  
  factory Barang.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing Barang JSON: $json');
      return _$BarangFromJson(json);
    } catch (e) {
      print('Error in Barang.fromJson: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
    
  Map<String, dynamic> toJson() => _$BarangToJson(this);
  
  List<String> get imageUrls => gambar.isNotEmpty 
    ? gambar.split(',').map((url) => url.trim()).toList() 
    : [];
  
  static double _stringToDouble(dynamic value) {
    // Handle null values
    if (value == null) {
      print('Warning: null value encountered, returning 0.0');
      return 0.0;
    }
    
    // Handle string values
    if (value is String) {
      if (value.isEmpty || value.toLowerCase() == 'null') {
        print('Warning: empty/null string encountered, returning 0.0');
        return 0.0;
      }
      try {
        return double.parse(value);
      } catch (e) {
        print('Error parsing string "$value" to double: $e');
        return 0.0;
      }
    }
    
    // Handle numeric values
    if (value is num) {
      return value.toDouble();
    }
    
    // Handle boolean values
    if (value is bool) {
      return value ? 1.0 : 0.0;
    }
    
    print('Warning: Cannot convert $value (${value.runtimeType}) to double, returning 0.0');
    return 0.0;
  }
  
  static DateTime? _stringToDateTime(dynamic value) {
    if (value == null) return null;
    
    if (value is String) {
      if (value.isEmpty || value.toLowerCase() == 'null') return null;
      try {
        return DateTime.parse(value);
      } catch (e) {
        print('Error parsing date "$value": $e');
        return null;
      }
    }
    
    if (value is DateTime) return value;
    return null;
  }
}