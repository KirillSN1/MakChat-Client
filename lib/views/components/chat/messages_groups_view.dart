import 'package:flutter/material.dart';
import 'package:matcha/models/chat_message/chat_message.dart';
import 'package:matcha/services/repositories/auth/auth_info.dart';
import 'package:matcha/views/components/chat/chat_message_view.dart';

class MessagesGroupView extends StatefulWidget {
  final List<ChatMessage> messages;
  final AuthInfo authInfo;
  const MessagesGroupView({super.key, required this.messages, required this.authInfo});
  @override
  State<MessagesGroupView> createState() => _MessagesGroupViewState();
}

class _MessagesGroupViewState extends State<MessagesGroupView> {
  @override
  Widget build(BuildContext context) {
    final me = widget.messages[0].authorId == widget.authInfo.user.id;
    return IntrinsicHeight(
      child: Row(
        // alignment: Alignment.bottomCenter,
        mainAxisAlignment: me?MainAxisAlignment.end:MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        // mainAxisSize: MainAxisSize.min,
        children: [
          if(!me) _buildAvatarColumn(),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: me?CrossAxisAlignment.end:CrossAxisAlignment.start,
            children: widget.messages.map((e) {
              return ChatMessageView(
                authInfo: widget.authInfo,
                message: e,
              );
            }).toList()
          ),
          if(me) _buildAvatarColumn()
        ],
      ),
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