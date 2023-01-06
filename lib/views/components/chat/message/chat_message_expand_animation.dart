import 'package:flutter/material.dart';
import 'package:matcha/views/components/chat/message/chat_message_view.dart';
import 'package:matcha/views/components/low/child_builder.dart';

class ChatMessageExpandAnimation extends StatelessWidget{
  final Animation<double>? controller;
  final Alignment? alignment;
  final ChatMessageView child;

  const ChatMessageExpandAnimation({
    super.key, 
    required this.controller, 
    this.alignment, 
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return ChildBuilder(
      builder: (context, child) {
        if(controller==null) return child;
        final fadeTransition = FadeTransition(
          opacity: controller!,
          child: child
        );
        return SizeTransition(
          sizeFactor: controller!,
          axisAlignment: -1,
          child: alignment!=null?Align(
            alignment: alignment!,
            child: fadeTransition
          ):fadeTransition,
        );
      },
      child: child
    );
  }
}