// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatsSearchResult _$ChatsSearchResultFromJson(Map<String, dynamic> json) =>
    ChatsSearchResult(
      users: (json['users'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      chats: (json['chats'] as List<dynamic>)
          .map((e) => Chat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatsSearchResultToJson(ChatsSearchResult instance) =>
    <String, dynamic>{
      'users': instance.users,
      'chats': instance.chats,
    };
