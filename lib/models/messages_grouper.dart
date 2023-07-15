import 'package:matcha/low/date_time_ext.dart';
import 'package:matcha/models/chat_message/chat_message.dart';

class MessagesGrouper{
  final List<MessagesGroup> _groups = [];
  List<MessagesGroup>  get groups=>_groups;
  List<ChatMessage> get messages {
    var messagesLists = _groups.map((g)=>g.messages);
    if(messagesLists.isEmpty) return [];
    return messagesLists.reduce((value, element) => value+element);
  }
  MessagesGrouper([Iterable<ChatMessage>? messages]){
    addAll(messages);
  }
  void addAll([Iterable<ChatMessage>? messages]){
    if(messages != null){
      for(final message in messages) {
        add(message);
      }
    }
  }
  void add(ChatMessage message){
    MessagesGroup? availableGroup;
    //сообщения в статусе "отправка", которые нужно опустить вниз
    // List<GrouperMessage> messagesOnSending = [];
    if(groups.isNotEmpty){
      for(var i = groups.length-1; i>=0; i--){
        final group = groups[i];
        //если попадается группа сообщений того же автора - группа найдена и
        //других действий не требуется
        if(group.matchByTime(message)) {
          if(group.userId != message.userId) break;
          availableGroup = group;
          break;
        }
      }
    }
    //добавляем сообщение и группу для него, если не нашлось подходящей
    if(availableGroup == null){
      availableGroup = MessagesGroup(message.userId, message.dateTime,[message]);
      final position = _getGroupPositionOnTimeline(availableGroup);
      if(position>=0) {
        groups.insert(position, availableGroup);
      } else {
        groups.add(availableGroup);
      }
    }
    else {
      availableGroup.messages.add(message);
    }
  }
  int _getGroupPositionOnTimeline(MessagesGroup group){
    return groups.indexWhere(
      (element) => 
        element.dateTime.millisecondsSinceEpoch > group.dateTime.millisecondsSinceEpoch
    );
  }
  bool removeMessage(ChatMessage message){
    for(var i = groups.length-1;i>=0;i--){
      final group = groups[i];
      if(group.messages.remove(message)) return true;
    }
    return false;
  }
  replace(ChatMessage from, ChatMessage to){
    for(var i = groups.length-1;i>=0;i--){
      final group = groups[i];
      final messageIndex = group.messages.indexOf(from);
      if(messageIndex>=0) {
        group.messages.replaceRange(messageIndex, messageIndex + 1, [to]);
        return true;
      }
    }
    return false;
  }
}
class MessagesGroup{
  static const Duration dateTimeRound = Duration(seconds: Duration.secondsPerMinute);
  final int userId;//автор
  final DateTime dateTime;//время с точностью до минуты
  List<ChatMessage> messages;
  MessagesGroup(this.userId, DateTime dateTime, [this.messages = const []])
    :dateTime = dateTime.roundDown(dateTimeRound);
  matchByTime(ChatMessage message){
    return message.dateTime.roundDown(dateTimeRound) == dateTime;
  }
}