// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bonus_top_seller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BonusTopSeller _$BonusTopSellerFromJson(Map<String, dynamic> json) =>
    BonusTopSeller(
      idBonusTopSeller: json['id_bonus_top_seller'] as String,
      idPenitip: json['id_penitip'] as String,
      nominal: (json['nominal'] as num).toDouble(),
      tanggalPembayaran: DateTime.parse(json['tanggal_pembayaran'] as String),
    );

Map<String, dynamic> _$BonusTopSellerToJson(BonusTopSeller instance) =>
    <String, dynamic>{
      'id_bonus_top_seller': instance.idBonusTopSeller,
      'id_penitip': instance.idPenitip,
      'nominal': instance.nominal,
      'tanggal_pembayaran': instance.tanggalPembayaran.toIso8601String(),
    };
