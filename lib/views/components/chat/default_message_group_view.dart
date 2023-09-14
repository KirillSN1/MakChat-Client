import 'package:flutter/material.dart';
import 'package:matcha/models/chat_message/chat_message.dart';
import 'message/chat_message_style_enum.dart';
import 'message/chat_message_view.dart';
import 'messages_groups_view.dart';

class ChatMessageBuilderData {
  final ChatMessage message;
  final bool me;
  final ChatMessageStyle style;
  final Widget Function() buildDefault;
  ChatMessageBuilderData._({
    required this.message,
    required this.style,
    required this.me,
    required this.buildDefault
  });
}
class DefaultMessagesGroupView extends MessagesGroupView{
  DefaultMessagesGroupView({
    super.key, 
    required int userId,
    required List<ChatMessage> messages,
    Widget Function(ChatMessageBuilderData data, int index)? builder
    // required Map<ChatMessage,AnimationController> messageAnimationControllers
  }) : super(
    userId: userId, 
    messages: messages,
    builder: (message,index) {
      final me = userId == message.data.userId;
      var style = ChatMessageStyle.first;
      if(index>0) {
        style = index == messages.length-1
        ?ChatMessageStyle.end:ChatMessageStyle.middle;
      } else if(index==messages.length-1){
        style = ChatMessageStyle.single;
      }
      buildMessageView(){
        return ChatMessageView(
          me: me,
          message: message,
          style: style,
        );
      }
      return Align(
        alignment: me?Alignment.centerRight:Alignment.centerLeft,
        child: builder?.call(ChatMessageBuilderData._(
          message:message,
          style:style,
          me:me,
          buildDefault: buildMessageView
        ), index) ?? buildMessageView()
      );
      // return ChatMessageExpandAnimation(
      //   controller: messageAnimationControllers[message],
      //   alignment: me?Alignment.centerRight:Alignment.centerLeft,
      //   child: ChatMessageView(
      //     userId: userId,
      //     message: message,
      //     style: style,
      //   ),
      // );
    },
  );
}