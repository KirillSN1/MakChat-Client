abstract class RepositoryError implements Exception{
  final String message;
  const RepositoryError(this.message);
  @override
  String toString() {
    return "RepositoryError: $message";
  }
}
class UnhandledRepositoryError extends RepositoryError{
  UnhandledRepositoryError(super.message);
}