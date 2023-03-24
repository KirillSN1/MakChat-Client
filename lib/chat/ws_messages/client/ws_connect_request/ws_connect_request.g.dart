// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_connect_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WSConnectRequest _$WSConnectRequestFromJson(Map<String, dynamic> json) =>
    WSConnectRequest(
      type: $enumDecodeNullable(_$WSMessageTypeEnumMap, json['type']) ??
          WSMessageType.connection,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$WSConnectRequestToJson(WSConnectRequest instance) =>
    <String, dynamic>{
      'type': _$WSMessageTypeEnumMap[instance.type]!,
      'token': instance.token,
    };

const _$WSMessageTypeEnumMap = {
  WSMessageType.connection: 'connection',
  WSMessageType.chat: 'chat',
  WSMessageType.chatList: 'chatList',
  WSMessageType.unknown: '',
};
