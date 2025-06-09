import 'package:json_annotation/json_annotation.dart';
import 'pembelian.dart';
import 'barang.dart';

part 'sub_pembelian.g.dart';

@JsonSerializable(explicitToJson: true)
class SubPembelian {
  @JsonKey(name: 'id_sub_pembelian')
  final String idSubPembelian;
  @JsonKey(name: 'id_pembelian')
  final String idPembelian;
  @JsonKey(name: 'id_barang')
  final String idBarang;
  @JsonKey(name: 'Pembelian')
  final Pembelian? pembelian;
  @JsonKey(name: 'Barang')
  final Barang? barang;

  SubPembelian({
    required this.idSubPembelian,
    required this.idPembelian,
    required this.idBarang,
    this.pembelian,
    this.barang,
  });

  factory SubPembelian.fromJson(Map<String, dynamic> json) => _$SubPembelianFromJson(json);
  Map<String, dynamic> toJson() => _$SubPembelianToJson(this);
}