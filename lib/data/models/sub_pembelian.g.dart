// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_pembelian.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubPembelian _$SubPembelianFromJson(Map<String, dynamic> json) => SubPembelian(
      idSubPembelian: json['id_sub_pembelian'] as String,
      idPembelian: json['id_pembelian'] as String,
      idBarang: json['id_barang'] as String,
      pembelian: json['Pembelian'] == null
          ? null
          : Pembelian.fromJson(json['Pembelian'] as Map<String, dynamic>),
      barang: json['Barang'] == null
          ? null
          : Barang.fromJson(json['Barang'] as Map<String, dynamic>),
      transaksi: json['Transaksi'] == null
          ? null
          : Transaksi.fromJson(json['Transaksi'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SubPembelianToJson(SubPembelian instance) =>
    <String, dynamic>{
      'id_sub_pembelian': instance.idSubPembelian,
      'id_pembelian': instance.idPembelian,
      'id_barang': instance.idBarang,
      'Pembelian': instance.pembelian?.toJson(),
      'Barang': instance.barang?.toJson(),
    };
