// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_chat_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WSChatRequest _$WSChatRequestFromJson(Map<String, dynamic> json) =>
    WSChatRequest._(
      id: json['id'] as int,
      chatId: json['chatId'] as int,
      text: json['text'] as String,
      type: $enumDecodeNullable(_$WSMessageTypeEnumMap, json['type']) ??
          WSMessageType.chat,
      dateTime: json['dateTime'] as int,
    );

Map<String, dynamic> _$WSChatRequestToJson(WSChatRequest instance) =>
    <String, dynamic>{
      'type': _$WSMessageTypeEnumMap[instance.type]!,
      'id': instance.id,
      'chatId': instance.chatId,
      'text': instance.text,
      'dateTime': instance.dateTime,
    };

const _$WSMessageTypeEnumMap = {
  WSMessageType.connection: 'connection',
  WSMessageType.chat: 'chat',
  WSMessageType.chatList: 'chatList',
  WSMessageType.unknown: '',
};
