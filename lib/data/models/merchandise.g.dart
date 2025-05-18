// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchandise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Merchandise _$MerchandiseFromJson(Map<String, dynamic> json) => Merchandise(
      idMerchandise: json['id_merchandise'] as String,
      idAdmin: json['id_admin'] as String,
      namaMerchandise: json['nama_merchandise'] as String,
      hargaPoin: (json['harga_poin'] as num).toInt(),
      deskripsi: json['deskripsi'] as String,
      gambar: json['gambar'] as String,
      stokMerchandise: (json['stok_merchandise'] as num).toInt(),
    );

Map<String, dynamic> _$MerchandiseToJson(Merchandise instance) =>
    <String, dynamic>{
      'id_merchandise': instance.idMerchandise,
      'id_admin': instance.idAdmin,
      'nama_merchandise': instance.namaMerchandise,
      'harga_poin': instance.hargaPoin,
      'deskripsi': instance.deskripsi,
      'gambar': instance.gambar,
      'stok_merchandise': instance.stokMerchandise,
    };
