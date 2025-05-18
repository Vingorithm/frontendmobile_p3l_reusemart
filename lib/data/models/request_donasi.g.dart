// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_donasi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestDonasi _$RequestDonasiFromJson(Map<String, dynamic> json) =>
    RequestDonasi(
      idRequestDonasi: json['id_request_donasi'] as String,
      idOrganisasi: json['id_organisasi'] as String,
      deskripsiRequest: json['deskripsi_request'] as String,
      tanggalRequest: DateTime.parse(json['tanggal_request'] as String),
      statusRequest: json['status_request'] as String,
    );

Map<String, dynamic> _$RequestDonasiToJson(RequestDonasi instance) =>
    <String, dynamic>{
      'id_request_donasi': instance.idRequestDonasi,
      'id_organisasi': instance.idOrganisasi,
      'deskripsi_request': instance.deskripsiRequest,
      'tanggal_request': instance.tanggalRequest.toIso8601String(),
      'status_request': instance.statusRequest,
    };
