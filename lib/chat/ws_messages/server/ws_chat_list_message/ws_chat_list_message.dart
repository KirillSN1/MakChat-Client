import 'package:json_annotation/json_annotation.dart';
import 'package:matcha/chat/ws_messages/ws_message_base.dart';
import 'package:matcha/chat/ws_messages/ws_message_types.dart';
import 'package:matcha/models/chat/chat.dart';
import 'package:matcha/structs/json.dart';
part 'ws_chat_list_message.g.dart';

@JsonSerializable()
class WSChatListMessage extends WSMessageBase {
  final List<Chat> chats;
  const WSChatListMessage(this.chats);
  @override
  final type = WSMessageType.chatList;

  factory WSChatListMessage.fromJson(Json json)=>_$WSChatListMessageFromJson(json);
  Json toJson()=>_$WSChatListMessageToJson(this);
}