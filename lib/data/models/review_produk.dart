import 'package:json_annotation/json_annotation.dart';

part 'review_produk.g.dart';

@JsonSerializable()
class ReviewProduk {
  @JsonKey(name: 'id_review')
  final String idReview;
  @JsonKey(name: 'id_transaksi')
  final String idTransaksi;
  final int rating;
  @JsonKey(name: 'tanggal_review')
  final DateTime tanggalReview;

  ReviewProduk({
    required this.idReview,
    required this.idTransaksi,
    required this.rating,
    required this.tanggalReview,
  });

  factory ReviewProduk.fromJson(Map<String, dynamic> json) => _$ReviewProdukFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewProdukToJson(this);
}