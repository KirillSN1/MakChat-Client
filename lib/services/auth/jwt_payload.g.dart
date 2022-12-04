// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jwt_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JWTPayload _$JWTPayloadFromJson(Map<String, dynamic> json) => JWTPayload(
      json['data'] as Map<String, dynamic>,
      json['iat'] as int,
      json['exp'] as int,
    );

Map<String, dynamic> _$JWTPayloadToJson(JWTPayload instance) =>
    <String, dynamic>{
      'iat': instance.iat,
      'exp': instance.exp,
      'data': instance.data,
    };
