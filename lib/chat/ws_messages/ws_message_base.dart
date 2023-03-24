import 'package:matcha/chat/ws_messages/ws_message_types.dart';
import 'package:matcha/structs/json.dart';

abstract class WSMessageBase{
  abstract final WSMessageType type;
  const WSMessageBase();
  Json toJson();
}