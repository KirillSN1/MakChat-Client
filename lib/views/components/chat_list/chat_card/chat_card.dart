import 'package:flutter/material.dart';
import 'package:matcha/models/chat.dart';
import 'package:matcha/models/chat_message/chat_message.dart';
import 'package:matcha/routes/app_route_enum.dart';
import 'package:matcha/routes/args/chat_args.dart';
import '../../../../env.dart';

class ChatCard extends StatelessWidget{
  final String chatName;
  final Widget? avatar;
  final ChatMessage? lastMessage;
  final void Function()? onTap;
  final bool isPeopleChat;

  const ChatCard(this.chatName, { super.key,  this.avatar, this.lastMessage, this.onTap, this.isPeopleChat = false });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: Hero(
                  tag: "avatar_$chatName",
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
                    if(isPeopleChat)
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