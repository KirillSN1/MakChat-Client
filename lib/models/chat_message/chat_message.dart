import 'package:equatable/equatable.dart';
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
  final int authorId;
  MessageStatus status;
  bool changed;
  ChatMessage(this.id, this.text, this.dateTime, this.authorId, this.status, this.changed);
  factory ChatMessage.create(String text, int authorId){
    return ChatMessage(
      ChatMessage.defaultId, 
      text, DateTime.now(), 
      authorId, 
      MessageStatus.sending,
      false
    );
  }
  factory ChatMessage.fromJson(Json json)=>_$ChatMessageFromJson(json);
}