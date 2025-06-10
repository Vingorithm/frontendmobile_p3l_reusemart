import 'package:json_annotation/json_annotation.dart';
import 'merchandise.dart';

part 'claim_merchandise.g.dart';

@JsonSerializable()
class ClaimMerchandise {
  @JsonKey(name: 'id_claim_merchandise')
  final String idClaimMerchandise;
  @JsonKey(name: 'id_merchandise')
  final String idMerchandise;
  @JsonKey(name: 'id_pembeli')
  final String idPembeli;
  @JsonKey(name: 'id_customer_service')
  final String idCustomerService;
  @JsonKey(name: 'tanggal_claim')
  final DateTime tanggalClaim;
  @JsonKey(name: 'tanggal_ambil')
  final DateTime? tanggalAmbil;
  @JsonKey(name: 'status_claim_merchandise')
  final String statusClaimMerchandise;
  @JsonKey(name: 'Merchandise')
  final Merchandise? merchandise;

  ClaimMerchandise({
    required this.idClaimMerchandise,
    required this.idMerchandise,
    required this.idPembeli,
    required this.idCustomerService,
    required this.tanggalClaim,
    this.tanggalAmbil,
    required this.statusClaimMerchandise,
    this.merchandise,
  });

  factory ClaimMerchandise.fromJson(Map<String, dynamic> json) => _$ClaimMerchandiseFromJson(json);
  Map<String, dynamic> toJson() => _$ClaimMerchandiseToJson(this);
}