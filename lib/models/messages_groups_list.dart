import 'package:matcha/low/date_time_ext.dart';
import 'package:matcha/models/chat_message/chat_message.dart';
import 'package:matcha/models/message_status.dart';

typedef _MessagesGroup = List<ChatMessage>;
// class MessagesGroupKey extends Equatable {
//   final int authorId;//автор
//   final int dateTime;//время с точностью до минуты
//   const MessagesGroupKey._(this.authorId, this.dateTime);
//   factory MessagesGroupKey.from(int authorId, DateTime dateTime, {Duration dateTimeRound = const Duration(seconds: Duration.secondsPerMinute)}){
//     final ms = dateTime.roundDown(dateTimeRound).millisecondsSinceEpoch;
//     return MessagesGroupKey._(authorId,ms);
//   }
//   factory MessagesGroupKey.fromMessage(ChatMessage message, {Duration dateTimeRound = const Duration(seconds: Duration.secondsPerMinute)}){
//     return MessagesGroupKey.from(message.authorId, message.dateTime, dateTimeRound: dateTimeRound);
//   }
//   @override
//   List<Object?> get props => [authorId,dateTime];
// }
class MessagesGrouper{
  final List<MessagesGroup> _groups = [];
  List<MessagesGroup>  get groups=>_groups;
  List<ChatMessage> get messages=>_groups.map((g)=>g.messages).reduce((value, element) => value+element);
  MessagesGrouper([List<ChatMessage>? messages]){
    if(messages != null){
      for(final message in messages) {
        add(message);
      }
    }
  }
  add(ChatMessage message){
    MessagesGroup? availableGroup;
    //сообщения в статусе "отправка", которые нужно опустить вниз
    List<ChatMessage> messagesOnSending = [];
    if(groups.isNotEmpty){
      for(var i = groups.length-1; i>=0; i--){
        final group = groups[i];
        //если попадается группа сообщений того же автора - группа найдена и
        //других действий не требуется
        if(group.match(message)) {
          availableGroup = group;
          break;
        }
        //если нет, то необходимо проверить есть ли у нас сообщения в статусе 
        //"отправка" и собрать их.
        if(i<groups.length-1 && messagesOnSending.isNotEmpty) break;
        final messagesOnSendingInGroup = group.messages.where(
          (element) => element.status == MessageStatus.sending
        );
        if(messagesOnSendingInGroup.isEmpty) break;
        //если группа состоит только из сообщенй в статусе "отпрака",
        //группу нужно удалить, а сообщения опустить вниз после 
        //добавления нового сообщения
        if(messagesOnSendingInGroup.length == group.messages.length){
          groups.remove(group);
          messagesOnSending.addAll(messagesOnSendingInGroup);
        }
        else {
          //если в группе есть сообщения "отправка" их таже нужно опустить вниз
          for (final element in messagesOnSendingInGroup) {
            group.messages.remove(element);
            messagesOnSending.add(element);
          }
        }
      }
    }
    //добавляем сообщение и группу для него, если не нашлось подходящей
    if(availableGroup == null){
      availableGroup = MessagesGroup(message.authorId, message.dateTime,[message]);
      groups.add(availableGroup);
    }
    else {
      availableGroup.messages.add(message);
    }
    if(messagesOnSending.isNotEmpty){
      //добавляем группу для сообщений в статусе "отправки"
      final authorId = messagesOnSending[0].authorId;
      availableGroup = MessagesGroup(authorId, DateTime.now(),messagesOnSending);
      groups.add(availableGroup);
    }
  }
  bool removeMessage(ChatMessage message){
    for(var i = groups.length-1;i>=0;i--){
      final group = groups[i];
      if(group.messages.remove(message)) return true;
    }
    return false;
  }
}
class MessagesGroup{
  static const Duration dateTimeRound = Duration(seconds: Duration.secondsPerMinute);
  final int authorId;//автор
  final DateTime dateTime;//время с точностью до минуты
  List<ChatMessage> messages;
  MessagesGroup(this.authorId, DateTime dateTime, [this.messages = const []])
    :dateTime = dateTime.roundDown(dateTimeRound);
  match(ChatMessage message){
    return message.authorId==authorId && message.dateTime.roundDown(dateTimeRound) == dateTime;
  }
}