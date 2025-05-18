// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keranjang.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Keranjang _$KeranjangFromJson(Map<String, dynamic> json) => Keranjang(
      idKeranjang: json['id_keranjang'] as String,
      idBarang: json['id_barang'] as String,
      idPembeli: json['id_pembeli'] as String,
    );

Map<String, dynamic> _$KeranjangToJson(Keranjang instance) => <String, dynamic>{
      'id_keranjang': instance.idKeranjang,
      'id_barang': instance.idBarang,
      'id_pembeli': instance.idPembeli,
    };
