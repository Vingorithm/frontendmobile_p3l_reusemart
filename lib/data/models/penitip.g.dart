// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'penitip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Penitip _$PenitipFromJson(Map<String, dynamic> json) => Penitip(
      idPenitip: json['id_penitip'] as String,
      idAkun: json['id_akun'] as String?,
      namaPenitip: json['nama_penitip'] as String,
      fotoKtp: json['foto_ktp'] as String,
      nomorKtp: json['nomor_ktp'] as String,
      keuntungan: Penitip._stringToDouble(json['keuntungan']),
      rating: Penitip._stringToDouble(json['rating']),
      badge: json['badge'] as bool,
      totalPoin: (json['total_poin'] as num?)?.toInt(),
      tanggalRegistrasi: json['tanggal_registrasi'] == null
          ? null
          : DateTime.parse(json['tanggal_registrasi'] as String),
      akun: json['akun'] == null
          ? null
          : Akun.fromJson(json['akun'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PenitipToJson(Penitip instance) => <String, dynamic>{
      'id_penitip': instance.idPenitip,
      'id_akun': instance.idAkun,
      'nama_penitip': instance.namaPenitip,
      'foto_ktp': instance.fotoKtp,
      'nomor_ktp': instance.nomorKtp,
      'keuntungan': instance.keuntungan,
      'rating': instance.rating,
      'badge': instance.badge,
      'total_poin': instance.totalPoin,
      'tanggal_registrasi': instance.tanggalRegistrasi?.toIso8601String(),
      'akun': instance.akun?.toJson(),
    };
