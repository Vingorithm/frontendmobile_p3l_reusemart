import 'package:json_annotation/json_annotation.dart';

part 'sub_pembelian.g.dart';

@JsonSerializable()
class SubPembelian {
  @JsonKey(name: 'id_sub_pembelian')
  final String idSubPembelian;
  @JsonKey(name: 'id_pembelian')
  final String idPembelian;
  @JsonKey(name: 'id_barang')
  final String idBarang;

  SubPembelian({
    required this.idSubPembelian,
    required this.idPembelian,
    required this.idBarang,
  });

  factory SubPembelian.fromJson(Map<String, dynamic> json) => _$SubPembelianFromJson(json);
  Map<String, dynamic> toJson() => _$SubPembelianToJson(this);
}