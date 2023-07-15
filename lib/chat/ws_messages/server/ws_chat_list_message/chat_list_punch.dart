import 'package:json_annotation/json_annotation.dart';
import 'package:matcha/chat/ws_messages/ws_structures.dart';
import 'package:matcha/chat/ws_messages/ws_message_types.dart';
import 'package:matcha/structs/json.dart';

import 'chat_list_punch_data.dart';
part 'chat_list_punch.g.dart';

@JsonSerializable()
class ChatListPunch extends Punch {
  final ChatListPunchData data;
  const ChatListPunch(this.data);
  @override
  final type = PunchType.chatList;

  factory ChatListPunch.fromJson(Json json)=>_$ChatListPunchFromJson(json);
  Json toJson()=>_$ChatListPunchToJson(this);
}