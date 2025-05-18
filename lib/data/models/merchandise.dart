import 'package:json_annotation/json_annotation.dart';

part 'merchandise.g.dart';

@JsonSerializable()
class Merchandise {
  @JsonKey(name: 'id_merchandise')
  final String idMerchandise;
  @JsonKey(name: 'id_admin')
  final String idAdmin;
  @JsonKey(name: 'nama_merchandise')
  final String namaMerchandise;
  @JsonKey(name: 'harga_poin')
  final int hargaPoin;
  final String deskripsi;
  final String gambar;
  @JsonKey(name: 'stok_merchandise')
  final int stokMerchandise;

  Merchandise({
    required this.idMerchandise,
    required this.idAdmin,
    required this.namaMerchandise,
    required this.hargaPoin,
    required this.deskripsi,
    required this.gambar,
    required this.stokMerchandise,
  });

  factory Merchandise.fromJson(Map<String, dynamic> json) => _$MerchandiseFromJson(json);
  Map<String, dynamic> toJson() => _$MerchandiseToJson(this);
}