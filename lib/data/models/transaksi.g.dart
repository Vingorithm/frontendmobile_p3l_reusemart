// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaksi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaksi _$TransaksiFromJson(Map<String, dynamic> json) => Transaksi(
      idTransaksi: json['id_transaksi'] as String,
      idSubPembelian: json['id_sub_pembelian'] as String,
      komisiReusemart: Transaksi._stringToDouble(json['komisi_reusemart']),
      komisiHunter: Transaksi._stringToDouble(json['komisi_hunter']),
      pendapatan: Transaksi._stringToDouble(json['pendapatan']),
      bonusCepat: Transaksi._stringToDouble(json['bonus_cepat']),
      subPembelian: json['SubPembelian'] == null
          ? null
          : SubPembelian.fromJson(json['SubPembelian'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransaksiToJson(Transaksi instance) => <String, dynamic>{
      'id_transaksi': instance.idTransaksi,
      'id_sub_pembelian': instance.idSubPembelian,
      'komisi_reusemart': instance.komisiReusemart,
      'komisi_hunter': instance.komisiHunter,
      'pendapatan': instance.pendapatan,
      'bonus_cepat': instance.bonusCepat,
      'SubPembelian': instance.subPembelian?.toJson(),
    };
