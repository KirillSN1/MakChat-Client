import 'package:json_annotation/json_annotation.dart';
import 'package:matcha/chat/ws_messages/ws_message_base.dart';
import 'package:matcha/chat/ws_messages/ws_message_types.dart';
import 'package:matcha/structs/json.dart';
part 'ws_chat_message.g.dart';

@JsonSerializable(constructor: "_")
class WSChatMessage extends WSMessageBase{
  @JsonKey(ignore: true)
  @override final WSMessageType type = WSMessageType.chat;
  final int id;
  final int chatId;
  final int appUserId;
  final int status;
  @JsonKey(fromJson: _numberFromString)
  final int created_at;
  @JsonKey(fromJson: _numberFromString)
  final int updated_at;
  @JsonKey(defaultValue: false) final bool changed;
  final String text;
  WSChatMessage._(this.id, this.chatId, this.appUserId, this.created_at, this.updated_at, this.text, this.status, this.changed);
  factory WSChatMessage.fromJson(Json json)=>_$WSChatMessageFromJson(json);
  Json toJson()=>_$WSChatMessageToJson(this);
  static _numberFromString(o)=>int.parse(o??0);
}