// lib/data/models/penitip.dart
import 'package:json_annotation/json_annotation.dart';
import 'akun.dart';

part 'penitip.g.dart';

@JsonSerializable(explicitToJson: true)
class Penitip {
  @JsonKey(name: 'id_penitip')
  final String idPenitip;

  @JsonKey(name: 'id_akun')
  final String? idAkun;

  @JsonKey(name: 'nama_penitip')
  final String namaPenitip;

  @JsonKey(name: 'foto_ktp')
  final String fotoKtp;

  @JsonKey(name: 'nomor_ktp')
  final String nomorKtp;

  @JsonKey(fromJson: _stringToDouble)
  final double? keuntungan;

  @JsonKey(fromJson: _stringToDouble)
  final double rating;

  @JsonKey(fromJson: _stringToBool)
  final bool badge;

  @JsonKey(name: 'total_poin')
  final int? totalPoin;

  @JsonKey(name: 'tanggal_registrasi')
  final DateTime? tanggalRegistrasi;

  final Akun? akun;

  Penitip({
    required this.idPenitip,
    this.idAkun,
    required this.namaPenitip,
    required this.fotoKtp,
    required this.nomorKtp,
    this.keuntungan,
    required this.rating,
    required this.badge,
    this.totalPoin,
    this.tanggalRegistrasi,
    this.akun,
  });

  factory Penitip.fromJson(Map<String, dynamic> json) => _$PenitipFromJson(json);
  Map<String, dynamic> toJson() => _$PenitipToJson(this);

  static double _stringToDouble(dynamic value) {
    if (value == null) {
      print('Warning: Rating is null, returning 0.0');
      return 0.0;
    }
    if (value is String) {
      if (value.isEmpty || value.toLowerCase() == 'null') {
        print('Warning: Rating is empty/null string, returning 0.0');
        return 0.0;
      }
      try {
        return double.parse(value);
      } catch (e) {
        print('Error parsing rating string "$value" to double: $e');
        return 0.0;
      }
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is bool) {
      return value ? 1.0 : 0.0;
    }
    print('Warning: Cannot convert rating $value (${value.runtimeType}) to double, returning 0.0');
    return 0.0;
  }

  static bool _stringToBool(dynamic value) {
    if (value == null) {
      print('Warning: Badge is null, returning false');
      return false;
    }

    if (value is bool) {
      return value;
    }
 
    if (value is String) {
      final lowerValue = value.toLowerCase();
      if (lowerValue == 'true' || lowerValue == '1') return true;
      if (lowerValue == 'false' || lowerValue == '0' || lowerValue == 'null' || lowerValue.isEmpty) return false;
      print('Warning: Unknown badge string value "$value", returning false');
      return false;
    }
    
    if (value is num) {
      return value != 0;
    }
    
    print('Warning: Cannot convert badge $value (${value.runtimeType}) to bool, returning false');
    return false;
  }
}