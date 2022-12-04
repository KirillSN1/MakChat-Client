import 'package:matcha/models/user.dart';

class AuthInfo{
  User user;
  String token;

  AuthInfo({ required this.token, required this.user });
  factory AuthInfo.jsonParse(Map<String, dynamic> json){
    return AuthInfo(
      token: json["token"] as String, 
      user: User.jsonParse(json["user"]) 
    );
  }
}