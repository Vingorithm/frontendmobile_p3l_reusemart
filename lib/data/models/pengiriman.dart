import 'package:json_annotation/json_annotation.dart';

part 'pengiriman.g.dart';

@JsonSerializable()
class Pengiriman {
  @JsonKey(name: 'id_pengiriman')
  final String idPengiriman;
  @JsonKey(name: 'id_pembelian')
  final String idPembelian;
  @JsonKey(name: 'id_pengkonfirmasi')
  final String idPengkonfirmasi;
  @JsonKey(name: 'tanggal_mulai')
  final DateTime tanggalMulai;
  @JsonKey(name: 'tanggal_berakhir')
  final DateTime? tanggalBerakhir;
  @JsonKey(name: 'status_pengiriman')
  final String statusPengiriman;
  @JsonKey(name: 'jenis_pengiriman')
  final String jenisPengiriman;

  Pengiriman({
    required this.idPengiriman,
    required this.idPembelian,
    required this.idPengkonfirmasi,
    required this.tanggalMulai,
    this.tanggalBerakhir,
    required this.statusPengiriman,
    required this.jenisPengiriman,
  });

  factory Pengiriman.fromJson(Map<String, dynamic> json) => _$PengirimanFromJson(json);
  Map<String, dynamic> toJson() => _$PengirimanToJson(this);
}