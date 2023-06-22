import 'package:json_annotation/json_annotation.dart';
import 'package:matcha/models/message_status.dart';
import 'package:matcha/structs/Json.dart';
part 'chat_message.g.dart';

@JsonSerializable()
class ChatMessage{
  static const defaultId = 0;
  static const defaultUserId = 0;
  int id;
  String text;
  DateTime dateTime;
  int userId;
  int chatId;
  MessageStatus status;
  bool changed;
  ChatMessage(this.id, this.text, this.dateTime, this.userId, this.chatId, this.status, this.changed);
  factory ChatMessage.create(int chatId, String text, [int userId = defaultUserId]){
    return ChatMessage(
      ChatMessage.defaultId, 
      text, DateTime.now(), 
      userId,
      chatId,
      MessageStatus.sending,
      false
    );
  }
  factory ChatMessage.fromJson(Json json)=>_$ChatMessageFromJson(json);
}