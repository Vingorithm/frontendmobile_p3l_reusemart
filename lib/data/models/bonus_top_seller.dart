import 'package:json_annotation/json_annotation.dart';

part 'bonus_top_seller.g.dart';

@JsonSerializable()
class BonusTopSeller {
  @JsonKey(name: 'id_bonus_top_seller')
  final String idBonusTopSeller;
  @JsonKey(name: 'id_penitip')
  final String idPenitip;
  final double nominal;
  @JsonKey(name: 'tanggal_pembayaran')
  final DateTime tanggalPembayaran;

  BonusTopSeller({
    required this.idBonusTopSeller,
    required this.idPenitip,
    required this.nominal,
    required this.tanggalPembayaran,
  });

  factory BonusTopSeller.fromJson(Map<String, dynamic> json) => _$BonusTopSellerFromJson(json);
  Map<String, dynamic> toJson() => _$BonusTopSellerToJson(this);
}