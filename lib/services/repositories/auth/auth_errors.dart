import 'package:matcha/services/repositories/errors.dart';

abstract class AuthError implements RepositoryError{
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
class IncorrectPasswordOrTokenError extends AuthError{
  IncorrectPasswordOrTokenError(super.message);
}