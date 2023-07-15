import 'package:flutter/material.dart';
import 'package:matcha/chat/ws_messages/server/ws_chat_list_message/chat_list_punch.dart';
import 'package:matcha/chat/ws_messages/server/ws_chat_list_message/chat_list_punch_data.dart';
import 'package:matcha/chat/ws_messages/ws_message_types.dart';
import 'package:matcha/routes/routes.dart';
import 'package:matcha/services/locator.dart';
import 'package:matcha/services/repositories/auth/auth_info.dart';
import 'package:matcha/services/repositories/chat_repository.dart';
import 'package:matcha/structs/json.dart';
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
    Locator.wsClient.receiver.addListener(PunchType.chatList.name, _onChatListPunch);
  }
  @override
  void dispose() {
    Locator.wsClient.receiver.removeListener(PunchType.chatList.name, _onChatListPunch);
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
      appBar: DefaultAppBar(info: _updating? "обновление...": null),
      body: Center(
        child: RefreshIndicator(
          onRefresh: updateChatsList,
          child: ListView(
            children: [
              for(final chat in chats)
                ChatCard(chat: chat, onTap: ()=>_onChatTap(context, chat))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>_onCreateChatButtonPress(context),
        tooltip: 'Написать',
        child: const Icon(Icons.edit),
      ),
    );
  }

  void _onChatListPunch(Json eventData){
    final punch = ChatListPunch.fromJson(eventData);
    setState(() {
      switch(punch.data.type){
        case ChatListPunchType.add:chats.addAll(punch.data.chats);
          break;
        case ChatListPunchType.remove:
          for(final chat in chats){
            chats.removeWhere((localChat)=>localChat.id==chat.id);
          }
          break;
        case ChatListPunchType.update:chats = punch.data.chats;
          break;
      }  
    });
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
      setState(() { _updating=false; });
    }
  }
}