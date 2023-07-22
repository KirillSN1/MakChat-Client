import 'package:json_annotation/json_annotation.dart';
import 'package:matcha/models/message_status.dart';
import 'package:matcha/structs/Json.dart';
part 'chat_message_data.g.dart';

@JsonSerializable()
class ChatMessageData{
  static const defaultId = 0;
  static const defaultUserId = 0;
  int id;
  String text;
  DateTime dateTime;
  int userId;
  int chatId;
  MessageStatus status;
  bool changed;
  ChatMessageData(this.id, this.text, this.dateTime, this.userId, this.chatId, this.status, this.changed);
  factory ChatMessageData.create(int chatId, String text, [int userId = defaultUserId]){
    return ChatMessageData(
      ChatMessageData.defaultId, 
      text, DateTime.now(), 
      userId,
      chatId,
      MessageStatus.sending,
      false
    );
  }
  factory ChatMessageData.fromJson(Json json)=>_$ChatMessageDataFromJson(json);
}