import 'package:json_annotation/json_annotation.dart';
import 'package:matcha/chat/ws_messages/server/chat_message_punch/chat_message_punch.dart';
import 'package:matcha/structs/json.dart';
part 'chat.g.dart';

@JsonSerializable()
class Chat{
  final int id;
  final int type;
  final String name;
  final int messagesCount;
  final List<int> users;
  final ChatMessagePunch? lastMessage;
  const Chat({
    required this.id, 
    this.type = 1, 
    this.name = "Unknown",
    this.users = const [],
    this.messagesCount = 0,
    this.lastMessage,
  });
  factory Chat.fromJson(Json json)=>_$ChatFromJson(json);
  Json toJson()=>_$ChatToJson(this);
}