abstract class RepositoryError implements Exception{
  final String message;
  RepositoryError(this.message);
}
class UnhandledRepositoryError extends RepositoryError{
  UnhandledRepositoryError(super.message);
}