import 'package:json_annotation/json_annotation.dart';
import 'package:matcha/structs/json.dart';
part 'user.g.dart';

@JsonSerializable()
class User{
  int id;
  String login;
  User({ required this.id, required this.login});
  factory User.fromJson(Json json)=>_$UserFromJson(json);
  toJson()=>_$UserToJson(this);
}