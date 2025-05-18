import 'package:json_annotation/json_annotation.dart';

part 'penitipan.g.dart';

@JsonSerializable()
class Penitipan {
  @JsonKey(name: 'id_penitipan')
  final String idPenitipan;
  @JsonKey(name: 'id_barang')
  final String idBarang;
  @JsonKey(name: 'tanggal_awal_penitipan')
  final DateTime tanggalAwalPenitipan;
  @JsonKey(name: 'tanggal_akhir_penitipan')
  final DateTime tanggalAkhirPenitipan;
  @JsonKey(name: 'tanggal_batas_pengambilan')
  final DateTime tanggalBatasPengambilan;
  final bool perpanjangan;
  @JsonKey(name: 'status_penitipan')
  final String statusPenitipan;

  Penitipan({
    required this.idPenitipan,
    required this.idBarang,
    required this.tanggalAwalPenitipan,
    required this.tanggalAkhirPenitipan,
    required this.tanggalBatasPengambilan,
    required this.perpanjangan,
    required this.statusPenitipan,
  });

  factory Penitipan.fromJson(Map<String, dynamic> json) => _$PenitipanFromJson(json);
  Map<String, dynamic> toJson() => _$PenitipanToJson(this);
}