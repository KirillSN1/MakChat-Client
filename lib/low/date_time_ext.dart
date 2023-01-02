extension DateTimeExtension on DateTime{
  DateTime roundDown(Duration delta){
    return DateTime.fromMillisecondsSinceEpoch(
      millisecondsSinceEpoch - millisecondsSinceEpoch % delta.inMilliseconds
    );
  }
}