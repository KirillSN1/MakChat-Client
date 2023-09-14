import 'package:flutter/material.dart';
import 'package:matcha/models/messages_grouping_model.dart';
import 'default_message_group_view.dart';

class ChatMessagesScrollView extends StatelessWidget {
  final ScrollController? controller;
  final int userId;
  final Iterable<MessagesGroup> groups;
  final Widget Function(ChatMessageBuilderData, int)? builder;
  const ChatMessagesScrollView({
    super.key, 
    this.controller,
    required this.userId,
    required this.groups,
    this.builder
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(//TODO:ленивая загрузка сообщений
      controller: controller,
      child:Column(
        children:[
          for(final messageGroup in groups)
            Padding(
              padding: const EdgeInsets.only(left: 3, right: 3, bottom: 6),
              child: DefaultMessagesGroupView(
                userId: userId,
                messages: messageGroup.messages,
                builder: builder
              ),
            )
        ]
      )
    );
  }
}