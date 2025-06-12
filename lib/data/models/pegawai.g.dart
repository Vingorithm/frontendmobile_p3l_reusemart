// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pegawai.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pegawai _$PegawaiFromJson(Map<String, dynamic> json) => Pegawai(
      idPegawai: json['id_pegawai'] as String,
      idAkun: json['id_akun'] as String,
      namaPegawai: json['nama_pegawai'] as String,
      tanggalLahir: DateTime.parse(json['tanggal_lahir'] as String),
      akun: json['Akun'] == null
          ? null
          : Akun.fromJson(json['Akun'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PegawaiToJson(Pegawai instance) => <String, dynamic>{
      'id_pegawai': instance.idPegawai,
      'id_akun': instance.idAkun,
      'nama_pegawai': instance.namaPegawai,
      'tanggal_lahir': instance.tanggalLahir.toIso8601String(),
      'Akun': instance.akun?.toJson(),
    };
