import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matcha/models/chat_message/chat_message.dart';
import 'package:matcha/models/message_status.dart';
import 'package:matcha/views/components/chat/message/chat_message_tail.dart';
import 'chat_message_style_enum.dart';

class ChatMessageView extends StatelessWidget {
  final ChatMessage message;
  final bool me;
  final ChatMessageStyle style;
  const ChatMessageView({
    super.key,
    required this.message,
    required this.me,
    this.style = ChatMessageStyle.middle 
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final time = DateFormat(DateFormat.HOUR24_MINUTE).format(message.data.dateTime);
    var padding = 3.0;
    final isLast = style == ChatMessageStyle.single || style == ChatMessageStyle.end;
    if(isLast) padding = 0;
    final messageDecoration = _getMessageDecoration(theme,me);
    return Padding(
      padding: EdgeInsets.only(
        bottom: padding
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: me?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          FractionallySizedBox(
            widthFactor: 0.9,
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: me?MainAxisAlignment.end:MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if(!me)  _getMessageTail(messageDecoration.color, me, isLast),
                  Flexible(
                    child: DecoratedBox(
                      decoration: messageDecoration,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(message.data.text,
                                  softWrap: true,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: Row(
                                children: [
                                  Text(time, style: theme.textTheme.bodySmall),
                                  if(me)
                                  SizedBox(
                                    height: 16,
                                    child: FittedBox(
                                      child: getStatusWidget(),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  if(me) _getMessageTail(messageDecoration.color, me, isLast)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _getMessageTail(Color? color, bool me, bool show){
    return ChatMessageTail(color: color,show: show, mirror: !me);
  }
  Widget getStatusWidget() {
    switch(message.data.status){
      case MessageStatus.sending: return  const CircularProgressIndicator();
      case MessageStatus.sended: return const Icon(Icons.done_rounded);
      case MessageStatus.readed: return const Icon(Icons.done_all_rounded);
    }
  }
  
  BoxDecoration _getMessageDecoration(ThemeData theme,bool me) {
    var borderRadius = const BorderRadius.all(Radius.circular(16));
    const cornerRadius = Radius.circular(4);
    const endCornerRadius = Radius.circular(0);
    final messageColor = me?theme.primaryColorLight:theme.backgroundColor;
    switch(style){
      case ChatMessageStyle.single:
        borderRadius = borderRadius.copyWith(
          bottomRight: me?endCornerRadius:null,
          bottomLeft: !me?endCornerRadius:null,
        );
        break;
      case ChatMessageStyle.first:
        borderRadius = borderRadius.copyWith(
          bottomRight: me?cornerRadius:null,
          bottomLeft: !me?cornerRadius:null,
        );
        break;
      case ChatMessageStyle.middle:
        final radiusRight = me?cornerRadius:null;
        final radiusLeft = !me?cornerRadius:null;
        borderRadius = borderRadius.copyWith(
          topRight: radiusRight,
          bottomRight: radiusRight,
          topLeft: radiusLeft,
          bottomLeft: radiusLeft,
        );
        break;
      case ChatMessageStyle.end:
        borderRadius = borderRadius.copyWith(
          topRight: me?cornerRadius:null,
          topLeft: !me?cornerRadius:null,
          bottomRight: me?endCornerRadius:null,
          bottomLeft: !me?endCornerRadius:null
        );
        break;
    }
    return BoxDecoration(
      borderRadius: borderRadius,
      color: messageColor
    );
  }
}