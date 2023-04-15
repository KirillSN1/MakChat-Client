// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_list_punch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatListPunch _$ChatListPunchFromJson(Map<String, dynamic> json) =>
    ChatListPunch(
      (json['chats'] as List<dynamic>)
          .map((e) => Chat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatListPunchToJson(ChatListPunch instance) =>
    <String, dynamic>{
      'chats': instance.chats,
    };
