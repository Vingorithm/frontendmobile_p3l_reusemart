// lib/data/models/pembelian.dart
import 'package:json_annotation/json_annotation.dart';
import 'pegawai.dart';
import 'pembeli.dart';
import 'alamat_pembeli.dart';

part 'pembelian.g.dart';

@JsonSerializable(explicitToJson: true)
class Pembelian {
  @JsonKey(name: 'id_pembelian')
  final String idPembelian;

  @JsonKey(name: 'id_customer_service')
  final String idCustomerService;

  @JsonKey(name: 'id_pembeli')
  final String idPembeli;

  @JsonKey(name: 'id_alamat')
  final String idAlamat;

  @JsonKey(name: 'bukti_transfer')
  final String? buktiTransfer;

  @JsonKey(name: 'tanggal_pembelian')
  final DateTime tanggalPembelian;

  @JsonKey(name: 'tanggal_pelunasan')
  final DateTime? tanggalPelunasan;

  @JsonKey(name: 'total_harga')
  final double totalHarga;

  final double ongkir;

  @JsonKey(name: 'potongan_poin')
  final int potonganPoin;

  @JsonKey(name: 'total_bayar')
  final double totalBayar;

  @JsonKey(name: 'poin_diperoleh')
  final int poinDiperoleh;

  @JsonKey(name: 'status_pembelian')
  final String statusPembelian;

  @JsonKey(name: 'CustomerService')
  final Pegawai? customerService;

  final Pembeli? pembeli;

  @JsonKey(name: 'Alamat')
  final AlamatPembeli? alamat;

  Pembelian({
    required this.idPembelian,
    required this.idCustomerService,
    required this.idPembeli,
    required this.idAlamat,
    this.buktiTransfer,
    required this.tanggalPembelian,
    this.tanggalPelunasan,
    required this.totalHarga,
    required this.ongkir,
    required this.potonganPoin,
    required this.totalBayar,
    required this.poinDiperoleh,
    required this.statusPembelian,
    this.customerService,
    this.pembeli,
    this.alamat,
  });

  factory Pembelian.fromJson(Map<String, dynamic> json) => _$PembelianFromJson(json);
  Map<String, dynamic> toJson() => _$PembelianToJson(this);
}