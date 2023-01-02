import 'package:flutter/material.dart';
import 'package:matcha/services/repositories/auth/auth_info.dart';
import 'package:matcha/views/components/chat_list/chat_card/chat_card.dart';
import 'package:matcha/views/components/default_drawer_header.dart';
import 'package:matcha/views/scaffold/default_app_bar.dart';
import '../models/chat.dart';
import '../routes/app_route_enum.dart';
import '../routes/args/chat_args.dart';

class MainView extends StatelessWidget{
  final AuthInfo args;
  const MainView({super.key, required this.args });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DefaultDrawerHeader(authInfo: args),
            // UserAccountsDrawerHeader(
            //   decoration: BoxDecoration(color: Theme.of(context).cardColor),
            //   onDetailsPressed: (){},

            //   currentAccountPicture: CircleAvatar(),
            //   accountName: Text("dddd"),
            //   accountEmail: Text("ddd")
            // )
          ],
        )
      ),
      appBar: DefaultAppBar(),
      body: Center(
        child: ListView(
          children: [
            ChatCard(
              "Временный чат",
              onTap: ()=>_onChatTap(context),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>Navigator.of(context).push(AppRoute.createChat.route.build(null)),
        tooltip: 'Написать',
        child: const Icon(Icons.edit),
      ),
    );
  }

  void _onChatTap(context) {
    var chat = Chat(name: "Временный чат",id:3);
    Navigator.of(context).push(AppRoute.chat.route.build(ChatArgs(chat:chat, authInfo: args)));
  }
}