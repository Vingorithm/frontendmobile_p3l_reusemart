// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organisasi_amal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrganisasiAmal _$OrganisasiAmalFromJson(Map<String, dynamic> json) =>
    OrganisasiAmal(
      idOrganisasi: json['id_organisasi'] as String,
      idAkun: json['id_akun'] as String,
      namaOrganisasi: json['nama_organisasi'] as String,
      alamat: json['alamat'] as String,
      tanggalRegistrasi: DateTime.parse(json['tanggal_registrasi'] as String),
    );

Map<String, dynamic> _$OrganisasiAmalToJson(OrganisasiAmal instance) =>
    <String, dynamic>{
      'id_organisasi': instance.idOrganisasi,
      'id_akun': instance.idAkun,
      'nama_organisasi': instance.namaOrganisasi,
      'alamat': instance.alamat,
      'tanggal_registrasi': instance.tanggalRegistrasi.toIso8601String(),
    };
