import 'package:json_annotation/json_annotation.dart';
import 'package:matcha/chat/ws_messages/ws_structures.dart';
import 'package:matcha/chat/ws_messages/ws_message_types.dart';
part 'chat_message_bullet.g.dart';

@JsonSerializable(constructor: "_")
class ChatMessageBullet extends Bullet{
  @override
  final PunchType type;
  final int id;
  final int chatId;
  final String text;
  final int dateTime;
  final int tempId;//id для ассоциации отправленного и полученного
  ///[dateTime] send or edit time (default is [DateTime.now])
  factory ChatMessageBullet({
    id = 0,
    chatId = 0,
    text = "",
    required int tempId,
    required int dateTime
  })=>ChatMessageBullet._(
    tempId: tempId,
    id: id,
    chatId: chatId,
    text: text,
    dateTime: dateTime
  );
  const ChatMessageBullet._({
    required this.tempId,
    required this.id,
    required this.chatId,
    required this.text,
    this.type = PunchType.chat,
    required this.dateTime
  });
  @override
  toJson()=>_$ChatMessageBulletToJson(this);
}