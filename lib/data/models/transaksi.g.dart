// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaksi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaksi _$TransaksiFromJson(Map<String, dynamic> json) => Transaksi(
      idTransaksi: json['id_transaksi'] as String,
      idSubPembelian: json['id_sub_pembelian'] as String,
      komisiReusemart: (json['komisi_reusemart'] as num).toDouble(),
      komisiHunter: (json['komisi_hunter'] as num).toDouble(),
      pendapatan: (json['pendapatan'] as num).toDouble(),
      bonusCepat: (json['bonus_cepat'] as num).toDouble(),
    );

Map<String, dynamic> _$TransaksiToJson(Transaksi instance) => <String, dynamic>{
      'id_transaksi': instance.idTransaksi,
      'id_sub_pembelian': instance.idSubPembelian,
      'komisi_reusemart': instance.komisiReusemart,
      'komisi_hunter': instance.komisiHunter,
      'pendapatan': instance.pendapatan,
      'bonus_cepat': instance.bonusCepat,
    };
