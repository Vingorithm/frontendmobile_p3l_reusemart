// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'akun.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Akun _$AkunFromJson(Map<String, dynamic> json) => Akun(
      idAkun: json['id_akun'] as String,
      profilePicture: json['profile_picture'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
      role: json['role'] as String,
      fcmToken: json['fcm_token'] as String?,
    );

Map<String, dynamic> _$AkunToJson(Akun instance) => <String, dynamic>{
      'id_akun': instance.idAkun,
      'profile_picture': instance.profilePicture,
      'email': instance.email,
      'password': instance.password,
      'role': instance.role,
      'fcm_token': instance.fcmToken,
    };
