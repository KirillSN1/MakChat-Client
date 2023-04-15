import 'package:get_it/get_it.dart';
import 'package:matcha/chat/ws_chat_client/ws_chat_client.dart';
import 'package:matcha/chat/ws_messages/client/ws_chat_request/chat_message_bullet.dart';
import 'package:matcha/chat/ws_messages/server/chat_message_punch/chat_message_punch.dart';
import 'package:matcha/chat/ws_messages/ws_message_types.dart';
import 'package:matcha/low/event.dart';
import 'package:matcha/models/chat_message/chat_message.dart';
import 'package:matcha/models/message_status.dart';
import 'package:matcha/services/repositories/auth/auth_info.dart';
import '../structs/json.dart';
import 'messages_groups_list.dart';

class MessagesChannel{
  final WSClient _client;
  late final onDisconnect = _client.onDisconnect;
  final onSended = Event<ChatMessage>();
  final onReceived = Event<ChatMessage>();
  final onReceivedChanged = Event<ChatMessage>();
  final MessagesGrouper _messagesGrouper = MessagesGrouper();
  final List<ChatMessage> _messagesInSending = [];

  List<MessagesGroup> get messagesGroups=>_messagesGrouper.groups;
  List<ChatMessage> get messages=>_messagesGrouper.messages;
  List<ChatMessage> get messagesInSending=>_messagesInSending;
  
  MessagesChannel._(this._client);
  ///Создает и возвращает экземпляр [MessagesChannel].
  ///ВНИМАНИЕ: для обмена сообщениями с сервером использует
  ///экземпляр класса [WSClient], зарегистрированный глобально при помощи [GetIt]
  static Future<MessagesChannel> create() async {
    final client = await GetIt.instance.getAsync<WSClient>();
    return MessagesChannel._(client);
  }
  void listen(){
    if(_client.onData.isListener(_onGiveMessage)) {
      throw Exception("Already listens!");
    }
    _client.onData.addListener(_onGiveMessage);
  }
  void stopListening(){
    _client.onData.removeListener(_onGiveMessage);
  }
  ChatMessage send(int chatId, String text){
    final message = ChatMessage.create(text, _client.userId);
    _messagesGrouper.add(message);
    _messagesInSending.add(message);
    _client.send(
      ChatMessageBullet(
        chatId:chatId,
        text: text,
        dateTime: message.dateTime.millisecondsSinceEpoch
      ),
      true
    );
    return message;
  }
  _onGiveMessage(Json messageJson){
    if(messageJson['type']!=PunchType.chat.name) return;
    ChatMessagePunch message = ChatMessagePunch.fromJson(messageJson['data']);
    ChatMessage chatMessage;
    if(message.userId == _client.userId){//если прилетело предположительно моё сообщение
      final chatMessageIndex = _messagesInSending.indexWhere((sm) {
        return sm.dateTime.millisecondsSinceEpoch == message.createdAt
          && sm.text == message.text;
      });
      if(chatMessageIndex>=0){//если я получил свое сообщение
        chatMessage = _messagesInSending[chatMessageIndex];
        _messagesInSending.remove(chatMessage);
        _copyFromWSMessage(message, chatMessage);
        onSended.invoke(chatMessage);
        return;
      }
    }
    final messages = _messagesGrouper.messages;
    final chatMessageIndex = messages.indexWhere((m)=>m.id==message.id);
    if(chatMessageIndex>=0){//если мне прилетело чужое сообщение
      chatMessage = messages[chatMessageIndex];
      _copyFromWSMessage(message, chatMessage);
      onReceivedChanged.invoke(chatMessage);
      return;
    }
    else{
      chatMessage = ChatMessage(
        message.id,
        message.text,
        DateTime.fromMillisecondsSinceEpoch(message.updatedAt),
        message.userId,
        MessageStatus.byValue(message.status,MessageStatus.sended),
        message.changed
      );
      _messagesGrouper.add(chatMessage);
      onReceived.invoke(chatMessage);
    }
  }
  _copyFromWSMessage(ChatMessagePunch from, ChatMessage to){
    to.id = from.id;
    to.status = MessageStatus.byValue(from.status);
    to.dateTime = DateTime.fromMillisecondsSinceEpoch(from.updatedAt);
    to.text = from.text;
    to.changed = from.changed;
  }
}