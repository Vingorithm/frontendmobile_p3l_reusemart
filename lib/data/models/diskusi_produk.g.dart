// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diskusi_produk.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiskusiProduk _$DiskusiProdukFromJson(Map<String, dynamic> json) =>
    DiskusiProduk(
      idDiskusiProduk: json['id_diskusi_produk'] as String,
      idBarang: json['id_barang'] as String,
      idCustomerService: json['id_customer_service'] as String,
      idPembeli: json['id_pembeli'] as String,
      pertanyaan: json['pertanyaan'] as String,
      jawaban: json['jawaban'] as String?,
      tanggalPertanyaan: DateTime.parse(json['tanggal_pertanyaan'] as String),
      tanggalJawaban: json['tanggal_jawaban'] == null
          ? null
          : DateTime.parse(json['tanggal_jawaban'] as String),
    );

Map<String, dynamic> _$DiskusiProdukToJson(DiskusiProduk instance) =>
    <String, dynamic>{
      'id_diskusi_produk': instance.idDiskusiProduk,
      'id_barang': instance.idBarang,
      'id_customer_service': instance.idCustomerService,
      'id_pembeli': instance.idPembeli,
      'pertanyaan': instance.pertanyaan,
      'jawaban': instance.jawaban,
      'tanggal_pertanyaan': instance.tanggalPertanyaan.toIso8601String(),
      'tanggal_jawaban': instance.tanggalJawaban?.toIso8601String(),
    };
