// lib/data/models/pegawai.dart
import 'package:json_annotation/json_annotation.dart';
import 'akun.dart';

part 'pegawai.g.dart';

@JsonSerializable(explicitToJson: true)
class Pegawai {
  @JsonKey(name: 'id_pegawai')
  final String idPegawai;

  @JsonKey(name: 'id_akun')
  final String idAkun;

  @JsonKey(name: 'nama_pegawai')
  final String namaPegawai;

  @JsonKey(name: 'tanggal_lahir')
  final DateTime tanggalLahir;

  @JsonKey(name: 'Akun')
  final Akun? akun;

  Pegawai({
    required this.idPegawai,
    required this.idAkun,
    required this.namaPegawai,
    required this.tanggalLahir,
    this.akun,
  });

  factory Pegawai.fromJson(Map<String, dynamic> json) => _$PegawaiFromJson(json);
  Map<String, dynamic> toJson() => _$PegawaiToJson(this);
}