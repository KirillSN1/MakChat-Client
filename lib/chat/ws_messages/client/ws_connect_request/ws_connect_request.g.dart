// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_connect_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WSConnectRequest _$WSConnectRequestFromJson(Map<String, dynamic> json) =>
    WSConnectRequest(
      type: $enumDecodeNullable(_$PunchTypeEnumMap, json['type']) ??
          PunchType.connection,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$WSConnectRequestToJson(WSConnectRequest instance) =>
    <String, dynamic>{
      'type': _$PunchTypeEnumMap[instance.type]!,
      'token': instance.token,
    };

const _$PunchTypeEnumMap = {
  PunchType.connection: 'connection',
  PunchType.chat: 'chat',
  PunchType.chatList: 'chatList',
  PunchType.unknown: '',
};
