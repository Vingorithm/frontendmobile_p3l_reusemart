import 'package:json_annotation/json_annotation.dart';
import 'pegawai.dart';
import 'pembeli.dart';
import 'alamat_pembeli.dart';
import 'pengiriman.dart';

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
  @JsonKey(name: 'total_harga', fromJson: _stringToDouble)
  final double totalHarga;
  @JsonKey(fromJson: _stringToDouble)
  final double ongkir;
  @JsonKey(name: 'potongan_poin', fromJson: _stringToInt)
  final int potonganPoin;
  @JsonKey(name: 'total_bayar', fromJson: _stringToDouble)
  final double totalBayar;
  @JsonKey(name: 'poin_diperoleh', fromJson: _stringToInt)
  final int poinDiperoleh;
  @JsonKey(name: 'status_pembelian')
  final String statusPembelian;
  @JsonKey(name: 'CustomerService')
  final Pegawai? customerService;
  final Pembeli? pembeli;
  @JsonKey(name: 'Alamat')
  final AlamatPembeli? alamat;
  final Pengiriman? pengiriman;

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
    this.pengiriman,
  });

  factory Pembelian.fromJson(Map<String, dynamic> json) {
    print('Parsing Pembelian JSON: $json');
    try {
      return _$PembelianFromJson(json);
    } catch (e, stackTrace) {
      print('Error in Pembelian.fromJson: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$PembelianToJson(this);

  static double _stringToDouble(dynamic value) {
    if (value == null || (value is String && (value.isEmpty || value.toLowerCase() == 'null'))) {
      print('Warning: Null or empty string for double, returning 0.0');
      return 0.0;
    }
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        print('Error parsing double from string "$value": $e');
        return 0.0;
      }
    }
    if (value is num) {
      return value.toDouble();
    }
    print('Warning: Cannot convert $value (${value.runtimeType}) to double, returning 0.0');
    return 0.0;
  }

  static int _stringToInt(dynamic value) {
    if (value == null || (value is String && (value.isEmpty || value.toLowerCase() == 'null'))) {
      print('Warning: Null or empty string for int, returning 0');
      return 0;
    }
    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        print('Error parsing int from string "$value": $e');
        return 0;
      }
    }
    if (value is num) {
      return value.toInt();
    }
    print('Warning: Cannot convert $value (${value.runtimeType}) to int, returning 0');
    return 0;
  }
}