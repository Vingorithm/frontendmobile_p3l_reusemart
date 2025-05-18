import 'package:json_annotation/json_annotation.dart';

part 'keranjang.g.dart';

@JsonSerializable()
class Keranjang {
  @JsonKey(name: 'id_keranjang')
  final String idKeranjang;
  @JsonKey(name: 'id_barang')
  final String idBarang;
  @JsonKey(name: 'id_pembeli')
  final String idPembeli;

  Keranjang({
    required this.idKeranjang,
    required this.idBarang,
    required this.idPembeli,
  });

  factory Keranjang.fromJson(Map<String, dynamic> json) => _$KeranjangFromJson(json);
  Map<String, dynamic> toJson() => _$KeranjangToJson(this);
}