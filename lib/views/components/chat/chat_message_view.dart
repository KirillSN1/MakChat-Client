import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matcha/models/chat_message/chat_message.dart';
import 'package:matcha/models/message_status.dart';
import 'package:matcha/services/repositories/auth/auth_info.dart';

class ChatMessageView extends StatelessWidget {
  final ChatMessage message;
  final bool me;
  final AuthInfo authInfo;
  ChatMessageView({super.key, required this.message, required this.authInfo })
    :me = message.authorId == authInfo.user.id;
  @override
  Widget build(BuildContext context) {
    final thame = Theme.of(context);
    // final colorScheme = thame.colorScheme;
    final time = DateFormat(DateFormat.HOUR24_MINUTE).format(message.dateTime);
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: me?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: me?MainAxisAlignment.end:MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16))
                      .copyWith(
                        bottomRight: me?const Radius.circular(2):null,
                        bottomLeft: !me?const Radius.circular(2):null,
                      ),
                    color: me?thame.primaryColorLight:thame.backgroundColor
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(message.text,
                              softWrap: true,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Row(
                            children: [
                              Text(time, style: thame.textTheme.bodySmall),
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
            ],
          ),
        ],
      ),
    );
  }
  
  Widget getStatusWidget() {
    switch(message.status){
      case MessageStatus.sending: return  const CircularProgressIndicator();
      case MessageStatus.sended: return const Icon(Icons.done_rounded);
      case MessageStatus.readed: return const Icon(Icons.done_all_rounded);
    }
  }
}

// class ChatMessage {
//   int id;
//   int authorId;
//   String value;
//   DateTime dateTime;
//   ChatMessage(this.id, this.authorId, this.dateTime, this.value);
// }