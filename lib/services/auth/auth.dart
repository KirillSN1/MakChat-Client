import 'package:matcha/services/auth/auth_token.dart';
import 'package:matcha/services/repositories/auth/auth_errors.dart';
import 'package:matcha/services/repositories/auth/auth_repository.dart';

class Auth{
  static Future<bool> signedIn() async {
    return (await AuthToken.get())?.isActual ?? false;
  }
  static Future<String?> get token async => (await AuthToken.get())?.value ?? "";
  static Future<SignInResult> signIn([String? login, String? password]) async {
    try {
      if(login == null && password == null) return SignInResult.notExists;
      final result = await AuthRepository.signIn(login:login, password:password);
      AuthToken.set(AuthToken.fromJWT(result.token));
    } on UserNotExistsError {
      return SignInResult.notExists;
    } on IncorrectPasswordOrTokenError {
      return SignInResult.incorrectPassword;
    }
    return SignInResult.success;
  }
  static Future<SignUpResult> signUp(String login, String password) async{
    try{
      final result = await AuthRepository.signUp(login, password);
      AuthToken.set(AuthToken.fromJWT(result.token));
      return SignUpResult.success;
    } on UserAlreadyExistsError {
      return SignUpResult.alreadyExists;
    }
  }
}
enum SignUpResult{
  success, alreadyExists
}
enum SignInResult{
  success, notExists, incorrectPassword
}