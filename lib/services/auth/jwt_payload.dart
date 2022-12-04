import 'package:json_annotation/json_annotation.dart';

part 'jwt_payload.g.dart';

@JsonSerializable()
class JWTPayload{
  final int iat;
  final int exp;
  final Map<String, dynamic> data;
  const JWTPayload(this.data, this.iat, this.exp);
  factory JWTPayload.fromJson(Map<String,dynamic> json)=>_$JWTPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$JWTPayloadToJson(this);
}