import 'package:flutter/material.dart';
import 'package:matcha/models/chat/chat.dart';
import 'package:matcha/models/chat_message/chat_message_data.dart';
import 'package:matcha/routes/app_route_enum.dart';
import 'package:matcha/routes/args/chat_args.dart';
import 'package:matcha/views/components/low/default_card.dart';
import '../../../../env.dart';

class ChatCard extends StatelessWidget{
  final String? chatName;
  final Widget? avatar;
  final ChatMessageData? lastMessage;
  final Chat? chat;
  final void Function()? onTap;
  final bool isPeopleChat;

  const ChatCard({ 
    this.chat,
    this.chatName,
    super.key,  
    this.avatar, 
    this.lastMessage, 
    this.onTap, 
    this.isPeopleChat = false
  });

  @override
  Widget build(BuildContext context) {
    return DefaultCard(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        radius: 300,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.bookmark_outline_rounded, color: Colors.white,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chatName ?? chat?.name ?? "Неизвестный чат"),
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