// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_chat_list_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WSChatListMessage _$WSChatListMessageFromJson(Map<String, dynamic> json) =>
    WSChatListMessage(
      (json['chats'] as List<dynamic>)
          .map((e) => Chat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WSChatListMessageToJson(WSChatListMessage instance) =>
    <String, dynamic>{
      'chats': instance.chats,
    };
