import 'package:json_annotation/json_annotation.dart';
import 'package:matcha/chat/ws_messages/ws_message_base.dart';
import 'package:matcha/chat/ws_messages/ws_message_types.dart';
part 'ws_chat_request.g.dart';

@JsonSerializable(constructor: "_")
class WSChatRequest extends WSMessageBase{
  @override
  final WSMessageType type;
  final int id;
  final String text;
  final int dateTime;
  ///[dateTime] send or edit time (default is [DateTime.now])
  factory WSChatRequest({
    id = 0,
    text = "",
    required int dateTime
  })=>WSChatRequest._(
    id: id,
    text: text,
    dateTime: dateTime
  );
  const WSChatRequest._({
    required this.id,
    required this.text,
    this.type = WSMessageType.chat,
    required this.dateTime
  });
  toJson()=>_$WSChatRequestToJson(this);
}