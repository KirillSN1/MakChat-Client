// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      json['id'] as int,
      json['text'] as String,
      DateTime.parse(json['dateTime'] as String),
      json['userId'] as int,
      $enumDecode(_$MessageStatusEnumMap, json['status']),
      json['changed'] as bool,
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'dateTime': instance.dateTime.toIso8601String(),
      'userId': instance.userId,
      'status': _$MessageStatusEnumMap[instance.status]!,
      'changed': instance.changed,
    };

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sended: 'sended',
  MessageStatus.readed: 'readed',
};
