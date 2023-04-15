import 'package:matcha/chat/ws_messages/ws_message_types.dart';
import 'package:matcha/structs/json.dart';

abstract class Punch{
  abstract final PunchType type;
  const Punch();
  Json toJson();
}
abstract class Bullet{
  abstract final PunchType type;
  const Bullet();
  Json toJson();
}