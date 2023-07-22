import 'package:flutter/material.dart';
import 'package:matcha/models/chat_message/chat_message.dart';
import 'package:matcha/services/repositories/auth/auth_info.dart';

class MessagesGroupView extends StatefulWidget {
  final List<ChatMessage> messages;
  final int userId;
  
  final Widget Function(int index) builder;
  const MessagesGroupView({super.key, required this.messages, required this.userId, required this.builder});
  @override
  State<MessagesGroupView> createState() => _MessagesGroupViewState();
}

class _MessagesGroupViewState extends State<MessagesGroupView> {
  @override
  Widget build(BuildContext context) {
    final me = widget.messages[0].data.userId == widget.userId;
    return Row(
      mainAxisAlignment: me?MainAxisAlignment.end:MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // if(!me) _buildAvatarColumn(),//TODO:Показывать аватар только в групповых чатах.
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: me?CrossAxisAlignment.end:CrossAxisAlignment.start,
            children: List.generate(
              widget.messages.length,
              (index)=>widget.builder(index)
            )
          ),
        ),
      ],
    );
  }
  
  Widget _buildAvatarColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(),
      ],
    );
  }
}