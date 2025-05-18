// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_produk.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewProduk _$ReviewProdukFromJson(Map<String, dynamic> json) => ReviewProduk(
      idReview: json['id_review'] as String,
      idTransaksi: json['id_transaksi'] as String,
      rating: (json['rating'] as num).toInt(),
      tanggalReview: DateTime.parse(json['tanggal_review'] as String),
    );

Map<String, dynamic> _$ReviewProdukToJson(ReviewProduk instance) =>
    <String, dynamic>{
      'id_review': instance.idReview,
      'id_transaksi': instance.idTransaksi,
      'rating': instance.rating,
      'tanggal_review': instance.tanggalReview.toIso8601String(),
    };
