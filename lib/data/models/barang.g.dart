// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barang.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Barang _$BarangFromJson(Map<String, dynamic> json) => Barang(
      idBarang: json['id_barang'] as String,
      idPenitip: json['id_penitip'] as String,
      idHunter: json['id_hunter'] as String?,
      idPegawaiGudang: json['id_pegawai_gudang'] as String,
      nama: json['nama'] as String,
      deskripsi: json['deskripsi'] as String,
      gambar: json['gambar'] as String,
      harga: Barang._stringToDouble(json['harga']),
      garansiBerlaku: json['garansi_berlaku'] as bool,
      tanggalGaransi: Barang._stringToDateTime(json['tanggal_garansi']),
      berat: Barang._stringToDouble(json['berat']),
      statusQc: json['status_qc'] as String,
      kategoriBarang: json['kategori_barang'] as String,
      penitip: json['Penitip'] == null
          ? null
          : Penitip.fromJson(json['Penitip'] as Map<String, dynamic>),
      hunter: json['Hunter'] == null
          ? null
          : Pegawai.fromJson(json['Hunter'] as Map<String, dynamic>),
      pegawaiGudang: json['PegawaiGudang'] == null
          ? null
          : Pegawai.fromJson(json['PegawaiGudang'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BarangToJson(Barang instance) => <String, dynamic>{
      'id_barang': instance.idBarang,
      'id_penitip': instance.idPenitip,
      'id_hunter': instance.idHunter,
      'id_pegawai_gudang': instance.idPegawaiGudang,
      'nama': instance.nama,
      'deskripsi': instance.deskripsi,
      'gambar': instance.gambar,
      'harga': instance.harga,
      'garansi_berlaku': instance.garansiBerlaku,
      'tanggal_garansi': instance.tanggalGaransi?.toIso8601String(),
      'berat': instance.berat,
      'status_qc': instance.statusQc,
      'kategori_barang': instance.kategoriBarang,
      'Penitip': instance.penitip?.toJson(),
      'Hunter': instance.hunter?.toJson(),
      'PegawaiGudang': instance.pegawaiGudang?.toJson(),
    };
