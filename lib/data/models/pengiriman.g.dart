// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pengiriman.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pengiriman _$PengirimanFromJson(Map<String, dynamic> json) => Pengiriman(
      idPengiriman: json['id_pengiriman'] as String,
      idPembelian: json['id_pembelian'] as String,
      idPengkonfirmasi: json['id_pengkonfirmasi'] as String?,
      tanggalMulai: json['tanggal_mulai'] == null
          ? null
          : DateTime.parse(json['tanggal_mulai'] as String),
      tanggalBerakhir: json['tanggal_berakhir'] == null
          ? null
          : DateTime.parse(json['tanggal_berakhir'] as String),
      statusPengiriman: json['status_pengiriman'] as String,
      jenisPengiriman: json['jenis_pengiriman'] as String,
      pegawai: json['Pegawai'] == null
          ? null
          : Pegawai.fromJson(json['Pegawai'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PengirimanToJson(Pengiriman instance) =>
    <String, dynamic>{
      'id_pengiriman': instance.idPengiriman,
      'id_pembelian': instance.idPembelian,
      'id_pengkonfirmasi': instance.idPengkonfirmasi,
      'tanggal_mulai': instance.tanggalMulai?.toIso8601String(),
      'tanggal_berakhir': instance.tanggalBerakhir?.toIso8601String(),
      'status_pengiriman': instance.statusPengiriman,
      'jenis_pengiriman': instance.jenisPengiriman,
      'Pegawai': instance.pegawai,
    };
