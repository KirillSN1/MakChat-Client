import 'package:json_annotation/json_annotation.dart';
import 'package:matcha/chat/ws_messages/ws_structures.dart';
import 'package:matcha/chat/ws_messages/ws_message_types.dart';
import 'package:matcha/structs/json.dart';
part 'ws_connect_message.g.dart';

@JsonSerializable(constructor: "_")
class WSConnectMessage extends Punch{
  @JsonKey(ignore: true)
  @override final PunchType type = PunchType.connection;
  final bool connected;
  @JsonKey(defaultValue: "") final String text;
  WSConnectMessage._(this.connected,this.text);
  factory WSConnectMessage.fromJson(Json json)=>_$WSConnectMessageFromJson(json);
  Json toJson()=>_$WSConnectMessageToJson(this);
}