import 'package:flutter/material.dart';
import 'package:matcha/routes/routes.dart';
import 'package:matcha/services/repositories/auth/auth_info.dart';
import 'package:matcha/services/repositories/chat_repository.dart';
import 'package:matcha/views/components/chat_list/chat_card/chat_card.dart';
import 'package:matcha/views/components/default_drawer_header.dart';
import 'package:matcha/views/scaffold/default_app_bar.dart';
import '../models/chat/chat.dart';
import '../routes/app_route_enum.dart';
import '../routes/args/chat_args.dart';

class MainView extends StatefulWidget{
  final AuthInfo authInfo;
  const MainView({super.key, required this.authInfo });

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<Chat> chats = [];
  
  bool _updating = false;
  @override
  void initState() {
    super.initState();
    updateChatsList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DefaultDrawerHeader(authInfo: widget.authInfo),
          ],
        )
      ),
      appBar: DefaultAppBar(),
      body: Center(
        child: ListView(
          children: [
            ChatCard(
              chatName: "Временный чат",
              onTap: ()=>_onChatTap(context,const Chat(name: "Временный чат",id:3)),
            ),
            for(final chat in chats)
              ChatCard(chat: chat, onTap: ()=>_onChatTap(context, chat))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>_onCreateChatButtonPress(context),
        tooltip: 'Написать',
        child: const Icon(Icons.edit),
      ),
    );
  }

  void _onChatTap(context,Chat chat) {
    final chatArgs = SingleChatArgs(chat:chat, authInfo: widget.authInfo);
    Navigator.of(context).push(AppRoute.chat.route.build(chatArgs));
  }

  void _onCreateChatButtonPress(BuildContext context) {
    final args = CreateChatArguments(widget.authInfo);
    Navigator.of(context).push(AppRoute.createChat.route.build(args));
  }

  Future updateChatsList() async {
    setState(() { _updating=true; });
    try{
      chats = List.from(await ChatRepository.getUserChats(widget.authInfo));
    } finally {
      setState(() { _updating=true; });
    }
  }
}