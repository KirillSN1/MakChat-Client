import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:matcha/env.dart';
import 'package:matcha/services/repositories/auth/auth_errors.dart';
import 'package:matcha/services/repositories/auth/auth_info.dart';


class AuthRepository{
  static Future<AuthInfo> signUp(String login, String password) async {
    final uri = Uri(
      scheme: Env.scheme, 
      host: Env.host, 
      port: Env.port,
      path: "/Api/signUp",
      queryParameters: {
        "login":login,
        "password":password
      }
    );
    final response = await http.get(uri);
    switch(response.statusCode){
      case(200):break;
      case(422):throw LoginFormatError(response.body);
      case(409):throw UserAlreadyExistsError(response.body);
      default:throw UnhandledAuthError(response.body);
    }
    final result = jsonDecode(response.body);
    return AuthInfo.jsonParse(result);
  }
  static Future<AuthInfo> signIn({String? login, String? password, String? token }) async {
    final uri = Uri(
      scheme: Env.scheme, 
      host: Env.host, 
      port: Env.port,
      path: "/Api/signIn",
      queryParameters: {
        "login":login,
        "password":password,
        "token":token
      }
    );
    final response = await http.get(uri);
    switch(response.statusCode){
      case(200):break;
      case(401):throw IncorrectPasswordOrTokenError(response.body);
      case(409):throw UserNotExistsError(response.body);
      default:throw UnhandledAuthError(response.body);
    }
    final result = jsonDecode(response.body);
    return AuthInfo.jsonParse(result);
  }
}