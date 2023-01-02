import 'dart:convert';

import 'package:matcha/models/user/user.dart';
import 'package:matcha/services/auth/auth_token.dart';
import 'package:matcha/services/repositories/auth/auth_info.dart';
import 'package:matcha/services/repositories/auth/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth{
  static const _lastUserStorageKey = "last_user";
  static Future<User?> get lastUser async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final row = sharedPreferences.getString(_lastUserStorageKey);
    if(row == null || row.isEmpty) return null;
    return User.fromJson(jsonDecode(row));
  }
  static Future<bool> _saveUser(User user) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final row = jsonEncode(user.toJson());
    return await sharedPreferences.setString(_lastUserStorageKey, row);
  }
  
  ///throws UnhandledRepositoryError
  static Future<AuthInfo?> signedIn() async {
    final authToken = await AuthToken.get();
    if(authToken == null) return null;
    return AuthRepository.signedIn(authToken.value);
  }
  ///signes in and saves token [AuthToken.save].
  ///throws IncorrectPasswordOrTokenError, UserNotExistsError
  static Future<AuthInfo> signIn(String login, String password) async {
    final result = await AuthRepository.signIn(login, password);
    AuthToken.save(AuthToken.fromJWT(result.token));
    await _saveUser(result.user);
    return result;
  }
  ///signes up and saves token [AuthToken.save].
  ///
  ///throws UserAlreadyExistsError
  static Future<AuthInfo> signUp(String login, String password) async{
    final result = await AuthRepository.signUp(login, password);
    AuthToken.save(AuthToken.fromJWT(result.token));
    await _saveUser(result.user);
    return result;
  }
  static Future signOut(){
    return AuthToken.remove();
  }
}