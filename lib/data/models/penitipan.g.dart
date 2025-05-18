// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'penitipan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Penitipan _$PenitipanFromJson(Map<String, dynamic> json) => Penitipan(
      idPenitipan: json['id_penitipan'] as String,
      idBarang: json['id_barang'] as String,
      tanggalAwalPenitipan:
          DateTime.parse(json['tanggal_awal_penitipan'] as String),
      tanggalAkhirPenitipan:
          DateTime.parse(json['tanggal_akhir_penitipan'] as String),
      tanggalBatasPengambilan:
          DateTime.parse(json['tanggal_batas_pengambilan'] as String),
      perpanjangan: json['perpanjangan'] as bool,
      statusPenitipan: json['status_penitipan'] as String,
    );

Map<String, dynamic> _$PenitipanToJson(Penitipan instance) => <String, dynamic>{
      'id_penitipan': instance.idPenitipan,
      'id_barang': instance.idBarang,
      'tanggal_awal_penitipan': instance.tanggalAwalPenitipan.toIso8601String(),
      'tanggal_akhir_penitipan':
          instance.tanggalAkhirPenitipan.toIso8601String(),
      'tanggal_batas_pengambilan':
          instance.tanggalBatasPengambilan.toIso8601String(),
      'perpanjangan': instance.perpanjangan,
      'status_penitipan': instance.statusPenitipan,
    };
