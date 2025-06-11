// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pembelian.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pembelian _$PembelianFromJson(Map<String, dynamic> json) => Pembelian(
      idPembelian: json['id_pembelian'] as String,
      idCustomerService: json['id_customer_service'] as String,
      idPembeli: json['id_pembeli'] as String,
      idAlamat: json['id_alamat'] as String,
      buktiTransfer: json['bukti_transfer'] as String?,
      tanggalPembelian: DateTime.parse(json['tanggal_pembelian'] as String),
      tanggalPelunasan: json['tanggal_pelunasan'] == null
          ? null
          : DateTime.parse(json['tanggal_pelunasan'] as String),
      totalHarga: Pembelian._stringToDouble(json['total_harga']),
      ongkir: Pembelian._stringToDouble(json['ongkir']),
      potonganPoin: Pembelian._stringToInt(json['potongan_poin']),
      totalBayar: Pembelian._stringToDouble(json['total_bayar']),
      poinDiperoleh: Pembelian._stringToInt(json['poin_diperoleh']),
      statusPembelian: json['status_pembelian'] as String,
      customerService: json['CustomerService'] == null
          ? null
          : Pegawai.fromJson(json['CustomerService'] as Map<String, dynamic>),
      pembeli: json['Pembeli'] == null
          ? null
          : Pembeli.fromJson(json['Pembeli'] as Map<String, dynamic>),
      alamat: json['AlamatPembeli'] == null
          ? null
          : AlamatPembeli.fromJson(json['AlamatPembeli'] as Map<String, dynamic>),
      pengiriman: json['Pengiriman'] == null
          ? null
          : Pengiriman.fromJson(json['Pengiriman'] as Map<String, dynamic>),
      subPembelians: json['SubPembelians'] == null
        ? []
        : (json['SubPembelians'] as List)
            .map((item) => SubPembelian.fromJson(item as Map<String, dynamic>))
            .toList(),
    );

Map<String, dynamic> _$PembelianToJson(Pembelian instance) => <String, dynamic>{
      'id_pembelian': instance.idPembelian,
      'id_customer_service': instance.idCustomerService,
      'id_pembeli': instance.idPembeli,
      'id_alamat': instance.idAlamat,
      'bukti_transfer': instance.buktiTransfer,
      'tanggal_pembelian': instance.tanggalPembelian.toIso8601String(),
      'tanggal_pelunasan': instance.tanggalPelunasan?.toIso8601String(),
      'total_harga': instance.totalHarga,
      'ongkir': instance.ongkir,
      'potongan_poin': instance.potonganPoin,
      'total_bayar': instance.totalBayar,
      'poin_diperoleh': instance.poinDiperoleh,
      'status_pembelian': instance.statusPembelian,
      'CustomerService': instance.customerService?.toJson(),
      'pembeli': instance.pembeli?.toJson(),
      'Alamat': instance.alamat?.toJson(),
      'pengiriman': instance.pengiriman?.toJson(),
    };
