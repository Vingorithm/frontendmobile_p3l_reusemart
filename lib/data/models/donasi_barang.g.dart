// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donasi_barang.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DonasiBarang _$DonasiBarangFromJson(Map<String, dynamic> json) => DonasiBarang(
      idDonasiBarang: json['id_donasi_barang'] as String,
      idRequestDonasi: json['id_request_donasi'] as String,
      idOwner: json['id_owner'] as String,
      idBarang: json['id_barang'] as String,
      tanggalDonasi: DateTime.parse(json['tanggal_donasi'] as String),
    );

Map<String, dynamic> _$DonasiBarangToJson(DonasiBarang instance) =>
    <String, dynamic>{
      'id_donasi_barang': instance.idDonasiBarang,
      'id_request_donasi': instance.idRequestDonasi,
      'id_owner': instance.idOwner,
      'id_barang': instance.idBarang,
      'tanggal_donasi': instance.tanggalDonasi.toIso8601String(),
    };
