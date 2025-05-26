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
      // Debug print untuk melihat data yang masuk
      print('Parsing Barang JSON: $json');
      
      // Validasi field yang wajib ada
      if (json['id_barang'] == null) throw FormatException('id_barang is null');
      if (json['nama'] == null) throw FormatException('nama is null');
      if (json['harga'] == null) throw FormatException('harga is null');
      if (json['berat'] == null) throw FormatException('berat is null');
      
      return _$BarangFromJson(json);
    } catch (e) {
      print('Error in Barang.fromJson: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
  
  Map<String, dynamic> toJson() => _$BarangToJson(this);

  List<String> get imageUrls => gambar.isNotEmpty ? gambar.split(',').map((url) => url.trim()).toList() : [];

  // Helper function untuk convert berbagai tipe data ke double
  static double _stringToDouble(dynamic value) {
    if (value == null) {
      print('Warning: null value encountered, returning 0.0');
      return 0.0;
    } else if (value is String) {
      if (value.isEmpty) {
        print('Warning: empty string encountered, returning 0.0');
        return 0.0;
      }
      try {
        return double.parse(value);
      } catch (e) {
        print('Error parsing string "$value" to double: $e');
        return 0.0;
      }
    } else if (value is num) {
      return value.toDouble();
    } else if (value is bool) {
      return value ? 1.0 : 0.0;
    }
    print('Warning: Cannot convert $value (${value.runtimeType}) to double, returning 0.0');
    return 0.0;
  }

  // Helper function untuk convert string ke DateTime
  static DateTime? _stringToDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      if (value.isEmpty) return null;
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