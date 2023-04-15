import 'package:json_annotation/json_annotation.dart';
import 'package:matcha/models/message_status.dart';
import 'package:matcha/structs/Json.dart';
part 'chat_message.g.dart';

@JsonSerializable()
class ChatMessage{
  static const defaultId = 0;
  int id;
  String text;
  DateTime dateTime;
  final int userId;
  MessageStatus status;
  bool changed;
  ChatMessage(this.id, this.text, this.dateTime, this.userId, this.status, this.changed);
  factory ChatMessage.create(String text, int userId){
    return ChatMessage(
      ChatMessage.defaultId, 
      text, DateTime.now(), 
      userId,
      MessageStatus.sending,
      false
    );
  }
  factory ChatMessage.fromJson(Json json)=>_$ChatMessageFromJson(json);
}