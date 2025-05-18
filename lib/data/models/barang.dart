// lib/data/models/barang_model.dart
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

  @JsonKey(name: 'tanggal_garansi')
  final DateTime? tanggalGaransi;

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

  factory Barang.fromJson(Map<String, dynamic> json) => _$BarangFromJson(json);
  Map<String, dynamic> toJson() => _$BarangToJson(this);

  List<String> get imageUrls => gambar.isNotEmpty ? gambar.split(',').map((url) => url.trim()).toList() : [];

  static double _stringToDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else if (value is num) {
      return value.toDouble();
    }
    throw FormatException('Cannot convert $value to double');
  }
}