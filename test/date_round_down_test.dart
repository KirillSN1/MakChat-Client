import 'package:flutter_test/flutter_test.dart';
import 'package:matcha/low/date_time_ext.dart';

void main() {
  test("DateTime.roundDown", () {
    final dateTime = DateTime.parse("2023-04-16 22:34:00");
    const delta = Duration(seconds: Duration.secondsPerMinute);
    final roundedDateTime = dateTime.roundDown(delta);
    expect(roundedDateTime.millisecondsSinceEpoch,dateTime.millisecondsSinceEpoch);
  });
}