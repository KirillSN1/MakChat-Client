// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_list_punch_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatListPunchData _$ChatListPunchDataFromJson(Map<String, dynamic> json) =>
    ChatListPunchData(
      (json['chats'] as List<dynamic>)
          .map((e) => Chat.fromJson(e as Map<String, dynamic>))
          .toList(),
      $enumDecode(_$ChatListPunchTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$ChatListPunchDataToJson(ChatListPunchData instance) =>
    <String, dynamic>{
      'chats': instance.chats,
      'type': _$ChatListPunchTypeEnumMap[instance.type]!,
    };

const _$ChatListPunchTypeEnumMap = {
  ChatListPunchType.add: 'add',
  ChatListPunchType.remove: 'remove',
  ChatListPunchType.update: 'update',
};
