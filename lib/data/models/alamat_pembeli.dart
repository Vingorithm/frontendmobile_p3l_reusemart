// lib/data/models/alamat_pembeli.dart
import 'package:json_annotation/json_annotation.dart';
import 'pembeli.dart';

part 'alamat_pembeli.g.dart';

@JsonSerializable(explicitToJson: true)
class AlamatPembeli {
  @JsonKey(name: 'id_alamat')
  final String idAlamat;

  @JsonKey(name: 'id_pembeli')
  final String idPembeli;

  @JsonKey(name: 'nama_alamat')
  final String namaAlamat;

  @JsonKey(name: 'alamat_lengkap')
  final String alamatLengkap;

  @JsonKey(name: 'is_main_address')
  final bool isMainAddress;

  final Pembeli? pembeli;

  AlamatPembeli({
    required this.idAlamat,
    required this.idPembeli,
    required this.namaAlamat,
    required this.alamatLengkap,
    required this.isMainAddress,
    this.pembeli,
  });

  factory AlamatPembeli.fromJson(Map<String, dynamic> json) => _$AlamatPembeliFromJson(json);
  Map<String, dynamic> toJson() => _$AlamatPembeliToJson(this);
}