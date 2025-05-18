import 'package:json_annotation/json_annotation.dart';

part 'transaksi.g.dart';

@JsonSerializable()
class Transaksi {
  @JsonKey(name: 'id_transaksi')
  final String idTransaksi;
  @JsonKey(name: 'id_sub_pembelian')
  final String idSubPembelian;
  @JsonKey(name: 'komisi_reusemart')
  final double komisiReusemart;
  @JsonKey(name: 'komisi_hunter')
  final double komisiHunter;
  final double pendapatan;
  @JsonKey(name: 'bonus_cepat')
  final double bonusCepat;

  Transaksi({
    required this.idTransaksi,
    required this.idSubPembelian,
    required this.komisiReusemart,
    required this.komisiHunter,
    required this.pendapatan,
    required this.bonusCepat,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) => _$TransaksiFromJson(json);
  Map<String, dynamic> toJson() => _$TransaksiToJson(this);
}