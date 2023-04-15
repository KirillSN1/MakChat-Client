import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField:"name")
enum PunchType{
  connection("connection"),
  chat("chat"),
  chatList("chatList"),
  unknown("");
  final String name;
  const PunchType(this.name);
  static PunchType fromString(String value){
    return PunchType.values.firstWhere((e) => e.name == value,
      orElse: ()=>PunchType.unknown);
  }
}