// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_connect_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WSConnectMessage _$WSConnectMessageFromJson(Map<String, dynamic> json) =>
    WSConnectMessage._(
      json['connected'] as bool,
      json['text'] as String? ?? '',
    );

Map<String, dynamic> _$WSConnectMessageToJson(WSConnectMessage instance) =>
    <String, dynamic>{
      'connected': instance.connected,
      'text': instance.text,
    };
