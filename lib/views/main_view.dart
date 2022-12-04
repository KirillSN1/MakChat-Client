import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:matcha/routes/args/main_args.dart';
import 'package:matcha/views/components/chat_list/chat_card/chat_card.dart';
import 'package:matcha/views/scaffold/default_app_bar.dart';

class MainView extends StatelessWidget{
  final MainArgs? args;
  const MainView({super.key, this.args });

  @override
  Widget build(BuildContext context) {
    // log(ThemeData.dark().primaryColor);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text(args?.user.login ?? "unknown")),
          ],
        )
      ),
      appBar: DefaultAppBar(),
      body: Center(
        child: ListView(
          children: [
            ChatCard("Hello")
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Increment',
        child: const Icon(Icons.edit),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}