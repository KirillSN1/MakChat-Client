import 'package:json_annotation/json_annotation.dart';
import 'package:matcha/models/chat/chat.dart';
import 'package:matcha/structs/Json.dart';
part 'chat_list_punch_data.g.dart';

enum ChatListPunchType{
  add,
  remove,
  update
}

@JsonSerializable()
class ChatListPunchData {
  final List<Chat> chats;
  final ChatListPunchType type;
  const ChatListPunchData(this.chats, this.type);
  factory ChatListPunchData.fromJson(Json json)=>_$ChatListPunchDataFromJson(json);
  Json toJson()=>_$ChatListPunchDataToJson(this);
}