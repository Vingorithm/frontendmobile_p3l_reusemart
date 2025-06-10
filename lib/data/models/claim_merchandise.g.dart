// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_merchandise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClaimMerchandise _$ClaimMerchandiseFromJson(Map<String, dynamic> json) =>
    ClaimMerchandise(
      idClaimMerchandise: json['id_claim_merchandise'] as String,
      idMerchandise: json['id_merchandise'] as String,
      idPembeli: json['id_pembeli'] as String,
      idCustomerService: json['id_customer_service'] as String,
      tanggalClaim: DateTime.parse(json['tanggal_claim'] as String),
      tanggalAmbil: json['tanggal_ambil'] == null
          ? null
          : DateTime.parse(json['tanggal_ambil'] as String),
      statusClaimMerchandise: json['status_claim_merchandise'] as String,
      merchandise: json['Merchandise'] == null
          ? null
          : Merchandise.fromJson(json['Merchandise'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClaimMerchandiseToJson(ClaimMerchandise instance) =>
    <String, dynamic>{
      'id_claim_merchandise': instance.idClaimMerchandise,
      'id_merchandise': instance.idMerchandise,
      'id_pembeli': instance.idPembeli,
      'id_customer_service': instance.idCustomerService,
      'tanggal_claim': instance.tanggalClaim.toIso8601String(),
      'tanggal_ambil': instance.tanggalAmbil?.toIso8601String(),
      'status_claim_merchandise': instance.statusClaimMerchandise,
      'Merchandise': instance.merchandise,
    };
