// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      id: json['id'] as int,
      type: json['type'] as int? ?? 1,
      name: json['name'] as String? ?? "Unknown",
      users: (json['users'] as List<dynamic>?)?.map((e) => e as int).toList() ??
          const [],
      messagesCount: json['messagesCount'] as int? ?? 0,
      lastMessage: json['lastMessage'] == null
          ? null
          : ChatMessagePunch.fromJson(
              json['lastMessage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'messagesCount': instance.messagesCount,
      'users': instance.users,
      'lastMessage': instance.lastMessage,
    };
