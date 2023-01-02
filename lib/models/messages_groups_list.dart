import 'package:equatable/equatable.dart';
import 'package:matcha/low/date_time_ext.dart';
import 'package:matcha/models/chat_message/chat_message.dart';

typedef _MessagesGroup = List<ChatMessage>;
class MessagesGroupKey extends Equatable {
  final int authorId;//автор
  final int dateTime;//время с точностью до минуты
  const MessagesGroupKey._(this.authorId, this.dateTime);
  factory MessagesGroupKey.from(int authorId, DateTime dateTime, {Duration dateTimeRound = const Duration(seconds: Duration.secondsPerMinute)}){
    final ms = dateTime.roundDown(dateTimeRound).millisecondsSinceEpoch;
    return MessagesGroupKey._(authorId,ms);
  }
  factory MessagesGroupKey.fromMessage(ChatMessage message, {Duration dateTimeRound = const Duration(seconds: Duration.secondsPerMinute)}){
    return MessagesGroupKey.from(message.authorId, message.dateTime, dateTimeRound: dateTimeRound);
  }
  @override
  List<Object?> get props => [authorId,dateTime];
}
class MessagesGrouper{
  final Map<MessagesGroupKey, _MessagesGroup> _groups = <MessagesGroupKey,_MessagesGroup>{};
  Map<MessagesGroupKey, List<ChatMessage>> get groups=>_groups;
  MessagesGrouper([List<ChatMessage>? messages]){
    if(messages != null){
      for(final message in messages) {
        add(message);
      }
    }
  }
  add(ChatMessage message){
    final key = MessagesGroupKey.fromMessage(message);
    var group = _groups[key];
    group ??= _groups[key] = [];
    group.add(message);
  }
  bool remove(ChatMessage message){
    final key = MessagesGroupKey.fromMessage(message);
    var group = _groups[key];
    if(group == null) return false;
    return group.remove(message);
  }
}