import 'package:matcha/services/repositories/errors.dart';

abstract class AuthError implements RepositoryError{
  @override final String message;
  AuthError(this.message);
}
class RequestArgumentsError extends RepositoryError{
  RequestArgumentsError(super.message);
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
class RequestNotFoundError extends RepositoryError{
  RequestNotFoundError(super.message);
}