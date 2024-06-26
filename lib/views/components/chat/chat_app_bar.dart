import 'package:flutter/material.dart';
import 'package:matcha/models/chat/chat.dart';
import 'package:matcha/views/components/custom_back_button.dart';
class ChatAppBar extends AppBar{
  ChatAppBar({super.key, required Chat? chat}):super(
    leading: const CustomBackButton(),
    automaticallyImplyLeading: true,
    title: Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Hero(
            tag: "avatar_${(chat?.id).toString()}",
            child: const CircleAvatar(
              radius: 23,
              backgroundColor: Colors.blue,
              child: Icon(Icons.bookmark_outline_rounded, color: Colors.white,),
            ),
          ),
        ),
        Expanded(child: Text(chat?.name??"...",overflow: TextOverflow.ellipsis))
      ],
    )
  );
  
}