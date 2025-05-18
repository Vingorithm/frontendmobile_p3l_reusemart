import 'package:json_annotation/json_annotation.dart';

part 'diskusi_produk.g.dart';

@JsonSerializable()
class DiskusiProduk {
  @JsonKey(name: 'id_diskusi_produk')
  final String idDiskusiProduk;
  @JsonKey(name: 'id_barang')
  final String idBarang;
  @JsonKey(name: 'id_customer_service')
  final String idCustomerService;
  @JsonKey(name: 'id_pembeli')
  final String idPembeli;
  final String pertanyaan;
  final String? jawaban;
  @JsonKey(name: 'tanggal_pertanyaan')
  final DateTime tanggalPertanyaan;
  @JsonKey(name: 'tanggal_jawaban')
  final DateTime? tanggalJawaban;

  DiskusiProduk({
    required this.idDiskusiProduk,
    required this.idBarang,
    required this.idCustomerService,
    required this.idPembeli,
    required this.pertanyaan,
    this.jawaban,
    required this.tanggalPertanyaan,
    this.tanggalJawaban,
  });

  factory DiskusiProduk.fromJson(Map<String, dynamic> json) => _$DiskusiProdukFromJson(json);
  Map<String, dynamic> toJson() => _$DiskusiProdukToJson(this);
}