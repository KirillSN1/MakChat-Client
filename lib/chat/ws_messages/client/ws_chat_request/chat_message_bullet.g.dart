// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_bullet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageBullet _$ChatMessageBulletFromJson(Map<String, dynamic> json) =>
    ChatMessageBullet._(
      tempId: json['tempId'] as int,
      id: json['id'] as int,
      chatId: json['chatId'] as int,
      text: json['text'] as String,
      type: $enumDecodeNullable(_$PunchTypeEnumMap, json['type']) ??
          PunchType.chat,
      dateTime: json['dateTime'] as int,
    );

Map<String, dynamic> _$ChatMessageBulletToJson(ChatMessageBullet instance) =>
    <String, dynamic>{
      'type': _$PunchTypeEnumMap[instance.type]!,
      'id': instance.id,
      'chatId': instance.chatId,
      'text': instance.text,
      'dateTime': instance.dateTime,
      'tempId': instance.tempId,
    };

const _$PunchTypeEnumMap = {
  PunchType.connection: 'connection',
  PunchType.chat: 'chat',
  PunchType.chatList: 'chatList',
  PunchType.unknown: '',
};
