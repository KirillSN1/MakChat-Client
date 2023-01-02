import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField:"name")
enum WSMessageType{
  connection("connection"),
  chat("chat"),
  unknown("");
  final String name;
  const WSMessageType(this.name);
  static WSMessageType fromString(String value){
    return WSMessageType.values.firstWhere((e) => e.name == value,
      orElse: ()=>WSMessageType.unknown);
  }
}