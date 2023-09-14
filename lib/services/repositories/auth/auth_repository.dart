import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:matcha/env.dart';
import 'package:matcha/services/repositories/auth/auth_errors.dart';
import 'package:matcha/services/repositories/auth/auth_info.dart';
import 'package:matcha/services/repositories/errors.dart';

import '../base_uri.dart';


class AuthRepository{
  static Future<AuthInfo> signUp(String login, String password) async {
    final response = await http.get(BaseUri.getWith(path: "/Api/signUp",
      queryParameters: {
        "login":login,
        "password":password
      }));
    switch(response.statusCode){
      case(200):break;
      case(422):throw RequestArgumentsError(response.body);
      case(409):throw UserAlreadyExistsError(response.body);
      default:throw UnhandledRepositoryError(response.body);
    }
    final result = jsonDecode(response.body);
    return AuthInfo.jsonParse(result);
  }
  ///throws UnhandledRepositoryError
  static Future<AuthInfo?> signedIn(String token) async {
    try{
      return await _signIn(token: token);
    } on IncorrectPasswordOrTokenError {
      return null;
    }
    on UserNotExistsError {
      return null;
    }
    catch (e){ rethrow; }
  }
  ///throws IncorrectPasswordOrTokenError, UserNotExistsError, UnhandledRepositoryError
  static Future<AuthInfo> signIn(String login, String password){
    return _signIn(login: login, password: password);
  }
  static Future<AuthInfo> _signIn({String? login, String? password, String? token }) async {
    final uri = BaseUri.getWith(path:"/Api/signIn", 
      queryParameters:{
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
      default:throw UnhandledRepositoryError(response.body);
    }
    final result = jsonDecode(response.body);
    return AuthInfo.jsonParse(result);
  }
}