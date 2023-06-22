// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:matcha/main.dart';
import 'package:matcha/models/chat/chat.dart';
import 'package:matcha/models/user/user.dart';
import 'package:matcha/routes/args/chat_args.dart';
import 'package:matcha/services/auth/auth.dart';
import 'package:matcha/services/locator.dart';
import 'package:matcha/services/repositories/auth/auth_info.dart';
import 'package:matcha/views/chat_view.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // var authInfo = await Auth.signedIn();
    var authInfo = await Auth.designIn("12345678", "12345678");
    Locator.init();
    await tester.pumpWidget(ChatView(
      args:SingleChatArgs(
        authInfo: authInfo!,
        chat: Chat(id: 0)
      ),
    ));
    
    // // Verify that our counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
