abstract class AuthError implements Exception{
  final String message;
  AuthError(this.message);
}
class LoginFormatError extends AuthError{
  LoginFormatError(super.message);
}
class UserAlreadyExistsError extends AuthError{
  UserAlreadyExistsError(super.message);
}
class UserNotExistsError extends AuthError{
  UserNotExistsError(super.message);
}
class UnhandledAuthError extends AuthError{
  UnhandledAuthError(super.message);
}
class IncorrectPasswordOrTokenError extends AuthError{
  IncorrectPasswordOrTokenError(super.message);
}