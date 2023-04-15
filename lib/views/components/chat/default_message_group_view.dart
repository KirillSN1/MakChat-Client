import 'package:flutter/material.dart';
import 'package:matcha/models/chat_message/chat_message.dart';
import 'message/chat_message_expand_animation.dart';
import 'message/chat_message_style_enum.dart';
import 'message/chat_message_view.dart';
import 'messages_groups_view.dart';

class DefaultMessagesGroupView extends MessagesGroupView{
  DefaultMessagesGroupView({
    super.key, 
    required int userId,
    required List<ChatMessage> messages,
    required Map<ChatMessage,AnimationController> messageAnimationControllers
  }) : super(
    userId: userId, 
    messages: messages,
    builder: (index) {
      final message = messages[index];
      final me = userId == message.userId;
      var style = ChatMessageStyle.first;
      if(index>0) {
        style = index == messages.length-1
        ?ChatMessageStyle.end:ChatMessageStyle.middle;
      } else if(index==messages.length-1){
        style = ChatMessageStyle.single;
      }
      return ChatMessageExpandAnimation(
        controller: messageAnimationControllers[message],
        alignment: me?Alignment.centerRight:Alignment.centerLeft,
        child: ChatMessageView(
          userId: userId,
          message: message,
          style: style,
        ),
      );
    },
  );

}