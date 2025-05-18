import 'package:json_annotation/json_annotation.dart';

part 'donasi_barang.g.dart';

@JsonSerializable()
class DonasiBarang {
  @JsonKey(name: 'id_donasi_barang')
  final String idDonasiBarang;
  @JsonKey(name: 'id_request_donasi')
  final String idRequestDonasi;
  @JsonKey(name: 'id_owner')
  final String idOwner;
  @JsonKey(name: 'id_barang')
  final String idBarang;
  @JsonKey(name: 'tanggal_donasi')
  final DateTime tanggalDonasi;

  DonasiBarang({
    required this.idDonasiBarang,
    required this.idRequestDonasi,
    required this.idOwner,
    required this.idBarang,
    required this.tanggalDonasi,
  });

  factory DonasiBarang.fromJson(Map<String, dynamic> json) => _$DonasiBarangFromJson(json);
  Map<String, dynamic> toJson() => _$DonasiBarangToJson(this);
}