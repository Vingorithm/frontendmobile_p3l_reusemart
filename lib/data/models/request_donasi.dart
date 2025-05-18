import 'package:json_annotation/json_annotation.dart';

part 'request_donasi.g.dart';

@JsonSerializable()
class RequestDonasi {
  @JsonKey(name: 'id_request_donasi')
  final String idRequestDonasi;
  @JsonKey(name: 'id_organisasi')
  final String idOrganisasi;
  @JsonKey(name: 'deskripsi_request')
  final String deskripsiRequest;
  @JsonKey(name: 'tanggal_request')
  final DateTime tanggalRequest;
  @JsonKey(name: 'status_request')
  final String statusRequest;

  RequestDonasi({
    required this.idRequestDonasi,
    required this.idOrganisasi,
    required this.deskripsiRequest,
    required this.tanggalRequest,
    required this.statusRequest,
  });

  factory RequestDonasi.fromJson(Map<String, dynamic> json) => _$RequestDonasiFromJson(json);
  Map<String, dynamic> toJson() => _$RequestDonasiToJson(this);
}