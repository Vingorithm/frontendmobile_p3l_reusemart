// lib/data/models/penitip.dart
import 'package:json_annotation/json_annotation.dart';
import 'akun.dart';

part 'penitip.g.dart';

@JsonSerializable(explicitToJson: true)
class Penitip {
  @JsonKey(name: 'id_penitip')
  final String idPenitip;

  @JsonKey(name: 'id_akun')
  final String? idAkun;

  @JsonKey(name: 'nama_penitip')
  final String namaPenitip;

  @JsonKey(name: 'foto_ktp')
  final String fotoKtp;

  @JsonKey(name: 'nomor_ktp')
  final String nomorKtp;

  final double? keuntungan;

  @JsonKey(fromJson: _stringToDouble)
  final double rating;

  final bool badge;

  @JsonKey(name: 'total_poin')
  final int? totalPoin;

  @JsonKey(name: 'tanggal_registrasi')
  final DateTime? tanggalRegistrasi;

  final Akun? akun;

  Penitip({
    required this.idPenitip,
    this.idAkun,
    required this.namaPenitip,
    required this.fotoKtp,
    required this.nomorKtp,
    this.keuntungan, // Updated
    required this.rating,
    required this.badge,
    this.totalPoin, // Updated
    this.tanggalRegistrasi, // Updated
    this.akun,
  });

  factory Penitip.fromJson(Map<String, dynamic> json) => _$PenitipFromJson(json);
  Map<String, dynamic> toJson() => _$PenitipToJson(this);

  static double _stringToDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else if (value is num) {
      return value.toDouble();
    }
    throw FormatException('Cannot convert $value to double');
  }
}