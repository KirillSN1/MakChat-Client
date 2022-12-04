import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matcha/models/chat_message.dart';
import 'package:matcha/models/message_status.dart';

class ChatMessageView extends StatelessWidget {
  final ChatMessage message;
  final bool me;
  ChatMessageView({super.key, required this.message }):me = message.authorId == 0;
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
                        Row(
                          children: [
                            Text(time, style: thame.textTheme.bodySmall),
                            SizedBox(
                              height: 20,
                              child: FittedBox(
                                child: getStatusWidget(),
                              ),
                            )
                          ],
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
      case MessgaeStatus.sending: return  const CircularProgressIndicator();
      case MessgaeStatus.sended: return const Icon(Icons.done_rounded);
      case MessgaeStatus.readed: return const Icon(Icons.done_all_rounded);
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