// lib/data/models/akun.dart
import 'package:json_annotation/json_annotation.dart';

part 'akun.g.dart';

@JsonSerializable(explicitToJson: true)
class Akun {
  @JsonKey(name: 'id_akun')
  final String idAkun;

  @JsonKey(name: 'profile_picture')
  final String profilePicture;

  final String email;
  final String password;
  final String role;

  @JsonKey(name: 'fcm_token')
  final String? fcmToken; // Nullable karena bisa kosong

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  Akun({
    required this.idAkun,
    required this.profilePicture,
    required this.email,
    required this.password,
    required this.role,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
  });

  factory Akun.fromJson(Map<String, dynamic> json) => _$AkunFromJson(json);
  Map<String, dynamic> toJson() => _$AkunToJson(this);
}