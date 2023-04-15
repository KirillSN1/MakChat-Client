import 'package:json_annotation/json_annotation.dart';
import 'package:matcha/chat/ws_messages/server/chat_message_punch/chat_message_punch.dart';
import 'package:matcha/structs/json.dart';
import '../chat/chat.dart';
import '../user/user.dart';
part 'chats_search_result.g.dart';

@JsonSerializable()
class ChatsSearchResult{
  final List<User> users;
  final List<Chat> chats;
  const ChatsSearchResult({
    required this.users,
    required this.chats
  });
  factory ChatsSearchResult.fromJson(Json json)=>_$ChatsSearchResultFromJson(json);
  Json toJson()=>_$ChatsSearchResultToJson(this);
}