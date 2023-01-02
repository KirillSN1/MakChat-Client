// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WSChatMessage _$WSChatMessageFromJson(Map<String, dynamic> json) =>
    WSChatMessage._(
      json['id'] as int,
      json['chatId'] as int,
      json['appUserId'] as int,
      WSChatMessage._numberFromString(json['created_at']),
      WSChatMessage._numberFromString(json['updated_at']),
      json['text'] as String,
      json['status'] as int,
      json['changed'] as bool? ?? false,
    );

Map<String, dynamic> _$WSChatMessageToJson(WSChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatId': instance.chatId,
      'appUserId': instance.appUserId,
      'status': instance.status,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'changed': instance.changed,
      'text': instance.text,
    };
