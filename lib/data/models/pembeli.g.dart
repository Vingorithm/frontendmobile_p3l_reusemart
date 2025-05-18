// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pembeli.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pembeli _$PembeliFromJson(Map<String, dynamic> json) => Pembeli(
      idPembeli: json['id_pembeli'] as String,
      idAkun: json['id_akun'] as String,
      nama: json['nama'] as String,
      totalPoin: (json['total_poin'] as num).toInt(),
      tanggalRegistrasi: DateTime.parse(json['tanggal_registrasi'] as String),
      akun: json['akun'] == null
          ? null
          : Akun.fromJson(json['akun'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PembeliToJson(Pembeli instance) => <String, dynamic>{
      'id_pembeli': instance.idPembeli,
      'id_akun': instance.idAkun,
      'nama': instance.nama,
      'total_poin': instance.totalPoin,
      'tanggal_registrasi': instance.tanggalRegistrasi.toIso8601String(),
      'akun': instance.akun?.toJson(),
    };
