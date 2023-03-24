import 'package:json_annotation/json_annotation.dart';
import 'package:matcha/chat/ws_messages/ws_message_base.dart';
import 'package:matcha/chat/ws_messages/ws_message_types.dart';
import 'package:matcha/structs/json.dart';
part 'ws_connect_request.g.dart';

@JsonSerializable()
class WSConnectRequest extends WSMessageBase{
  @override final WSMessageType type;
  final String? token;
  const WSConnectRequest({ this.type = WSMessageType.connection, required this.token});
  Json toJson()=>_$WSConnectRequestToJson(this);
}