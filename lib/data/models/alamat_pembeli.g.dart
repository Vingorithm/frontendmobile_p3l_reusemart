// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alamat_pembeli.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlamatPembeli _$AlamatPembeliFromJson(Map<String, dynamic> json) =>
    AlamatPembeli(
      idAlamat: json['id_alamat'] as String,
      idPembeli: json['id_pembeli'] as String,
      namaAlamat: json['nama_alamat'] as String,
      alamatLengkap: json['alamat_lengkap'] as String,
      isMainAddress: json['is_main_address'] as bool,
      pembeli: json['pembeli'] == null
          ? null
          : Pembeli.fromJson(json['pembeli'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AlamatPembeliToJson(AlamatPembeli instance) =>
    <String, dynamic>{
      'id_alamat': instance.idAlamat,
      'id_pembeli': instance.idPembeli,
      'nama_alamat': instance.namaAlamat,
      'alamat_lengkap': instance.alamatLengkap,
      'is_main_address': instance.isMainAddress,
      'pembeli': instance.pembeli?.toJson(),
    };
