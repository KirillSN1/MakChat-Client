import 'package:json_annotation/json_annotation.dart';
import 'package:matcha/chat/ws_messages/ws_structures.dart';
import 'package:matcha/chat/ws_messages/ws_message_types.dart';
import 'package:matcha/structs/json.dart';
part 'chat_message_punch.g.dart';

@JsonSerializable(constructor: "_")
class ChatMessagePunch extends Punch{
  @JsonKey(ignore: true)
  @override final PunchType type = PunchType.chat;
  final int id;
  final int userId;
  final int status;
  @JsonKey(fromJson: _numberFromString, name: "created_at")
  final int createdAt;
  @JsonKey(fromJson: _numberFromString, name: "updated_at")
  final int updatedAt;
  @JsonKey(defaultValue: false) final bool changed;
  final String text;
  ChatMessagePunch._(this.id, this.userId, this.createdAt, this.updatedAt, this.text, this.status, this.changed);
  factory ChatMessagePunch.fromJson(Json json)=>_$ChatMessagePunchFromJson(json);
  @override Json toJson()=>_$ChatMessagePunchToJson(this);
  static _numberFromString(o)=>int.parse(o??0);
}