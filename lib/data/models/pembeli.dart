// lib/data/models/pembeli.dart
import 'package:json_annotation/json_annotation.dart';
import 'akun.dart';

part 'pembeli.g.dart';

@JsonSerializable(explicitToJson: true)
class Pembeli {
  @JsonKey(name: 'id_pembeli')
  final String idPembeli;

  @JsonKey(name: 'id_akun')
  final String idAkun;

  final String nama;

  @JsonKey(name: 'total_poin')
  final int totalPoin;

  @JsonKey(name: 'tanggal_registrasi')
  final DateTime tanggalRegistrasi;

  @JsonKey(name: 'Akun')
  final Akun? akun;

  Pembeli({
    required this.idPembeli,
    required this.idAkun,
    required this.nama,
    required this.totalPoin,
    required this.tanggalRegistrasi,
    this.akun,
  });

  factory Pembeli.fromJson(Map<String, dynamic> json) => _$PembeliFromJson(json);
  Map<String, dynamic> toJson() => _$PembeliToJson(this);
}