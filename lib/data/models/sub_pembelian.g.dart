// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_pembelian.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubPembelian _$SubPembelianFromJson(Map<String, dynamic> json) => SubPembelian(
      idSubPembelian: json['id_sub_pembelian'] as String,
      idPembelian: json['id_pembelian'] as String,
      idBarang: json['id_barang'] as String,
    );

Map<String, dynamic> _$SubPembelianToJson(SubPembelian instance) =>
    <String, dynamic>{
      'id_sub_pembelian': instance.idSubPembelian,
      'id_pembelian': instance.idPembelian,
      'id_barang': instance.idBarang,
    };
