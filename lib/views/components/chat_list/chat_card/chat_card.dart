import 'package:flutter/material.dart';
import 'package:matcha/models/chat.dart';
import 'package:matcha/models/chat_message.dart';
import 'package:matcha/routes/app_route_enum.dart';
import 'package:matcha/routes/args/chat_args.dart';
import '../../../../env.dart';

class ChatCard extends StatelessWidget{
  final String chatName;
  final Widget? avatar;
  final ChatMessage? lastMessage;

  const ChatCard(this.chatName, { super.key,  this.avatar, this.lastMessage });

  @override
  Widget build(BuildContext context) {
    final chat = Chat(id: 888, name: chatName);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(AppRoute.chat.route.build(null, ChatArgs(chat))),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: Hero(
                  tag: "avatar_${chat.id.toString()}",
                  child: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.bookmark_outline_rounded, color: Colors.white,),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chatName),
                    Text(lastMessage?.text ?? "$chatName теперь в ${Env.appTitile}!")
                  ],
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}