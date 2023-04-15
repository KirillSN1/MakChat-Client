// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_punch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessagePunch _$ChatMessagePunchFromJson(Map<String, dynamic> json) =>
    ChatMessagePunch._(
      json['id'] as int,
      json['userId'] as int,
      ChatMessagePunch._numberFromString(json['created_at']),
      ChatMessagePunch._numberFromString(json['updated_at']),
      json['text'] as String,
      json['status'] as int,
      json['changed'] as bool? ?? false,
    );

Map<String, dynamic> _$ChatMessagePunchToJson(ChatMessagePunch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'status': instance.status,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'changed': instance.changed,
      'text': instance.text,
    };
