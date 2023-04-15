import 'package:json_annotation/json_annotation.dart';
import 'package:matcha/chat/ws_messages/ws_structures.dart';
import 'package:matcha/chat/ws_messages/ws_message_types.dart';
import 'package:matcha/structs/json.dart';
part 'ws_connect_request.g.dart';

@JsonSerializable()
class WSConnectRequest extends Punch{
  @override final PunchType type;
  final String? token;
  const WSConnectRequest({ this.type = PunchType.connection, required this.token});
  Json toJson()=>_$WSConnectRequestToJson(this);
}