import 'package:json_annotation/json_annotation.dart';

part 'organisasi_amal.g.dart';

@JsonSerializable()
class OrganisasiAmal {
  @JsonKey(name: 'id_organisasi')
  final String idOrganisasi;
  @JsonKey(name: 'id_akun')
  final String idAkun;
  @JsonKey(name: 'nama_organisasi')
  final String namaOrganisasi;
  final String alamat;
  @JsonKey(name: 'tanggal_registrasi')
  final DateTime tanggalRegistrasi;

  OrganisasiAmal({
    required this.idOrganisasi,
    required this.idAkun,
    required this.namaOrganisasi,
    required this.alamat,
    required this.tanggalRegistrasi,
  });

  factory OrganisasiAmal.fromJson(Map<String, dynamic> json) => _$OrganisasiAmalFromJson(json);
  Map<String, dynamic> toJson() => _$OrganisasiAmalToJson(this);
}