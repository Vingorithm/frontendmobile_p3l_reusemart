import 'package:json_annotation/json_annotation.dart';
import 'sub_pembelian.dart';

part 'transaksi.g.dart';

@JsonSerializable(explicitToJson: true)
class Transaksi {
  @JsonKey(name: 'id_transaksi')
  final String idTransaksi;
  @JsonKey(name: 'id_sub_pembelian')
  final String idSubPembelian;
  @JsonKey(name: 'komisi_reusemart', fromJson: _stringToDouble)
  final double komisiReusemart;
  @JsonKey(name: 'komisi_hunter', fromJson: _stringToDouble)
  final double komisiHunter;
  @JsonKey(fromJson: _stringToDouble)
  final double pendapatan;
  @JsonKey(name: 'bonus_cepat', fromJson: _stringToDouble)
  final double bonusCepat;
  @JsonKey(name: 'SubPembelian')
  final SubPembelian? subPembelian;

  Transaksi({
    required this.idTransaksi,
    required this.idSubPembelian,
    required this.komisiReusemart,
    required this.komisiHunter,
    required this.pendapatan,
    required this.bonusCepat,
    this.subPembelian,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) => _$TransaksiFromJson(json);
  Map<String, dynamic> toJson() => _$TransaksiToJson(this);

  static double _stringToDouble(dynamic value) {
    if (value == null || (value is String && (value.isEmpty || value.toLowerCase() == 'null'))) {
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
}