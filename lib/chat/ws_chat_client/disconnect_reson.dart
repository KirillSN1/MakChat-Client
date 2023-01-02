class DisconnectReson{
  final int code;
  final String message;
  static const int authError = 4001;
  static const int argumentsError = 4100;
  static const int normal = 1000;
  const DisconnectReson(this.code, this.message);
}