import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:matcha/chat/ws_chat_client/ws_chat_client.dart';
import 'package:matcha/chat/ws_messages/client/ws_chat_request/chat_message_bullet.dart';
import 'package:matcha/chat/ws_messages/server/chat_message_punch/chat_message_punch.dart';
import 'package:matcha/chat/ws_messages/ws_message_types.dart';
import 'package:matcha/low/event.dart';
import 'package:matcha/models/chat_message/chat_message_data.dart';
import '../structs/json.dart';

class SendedMessageEventData{
  ChatMessageData sended;
  ChatMessageData recirved;
  SendedMessageEventData(this.sended,this.recirved);
}
class MessagesChannel{
  final WSClient _client;
  final int _userId;
  final Map<int,Completer<ChatMessageData>> _sendCompleters = {};
  late final onDisconnect = _client.onDisconnect;
  late final onAuthError = _client.onAuthError;
  final onReceived = Event<ChatMessageData>();
  
  MessagesChannel._(this._client,this._userId);
  ///Создает и возвращает экземпляр [MessagesChannel].
  ///ВНИМАНИЕ: для обмена сообщениями с сервером использует
  ///экземпляр класса [WSClient], зарегистрированный глобально при помощи [GetIt]
  static MessagesChannel create() {
    final client = GetIt.instance.get<WSClient>();
    return MessagesChannel._(client,client.userId);
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
  ///Отправляет сообщение [text] в чат с идентификатором [chatId]
  ///Если клинтнт не подключен или не авторизован [ChatMessageData.userId]
  ///будет присвоено значение 0.
  ///После авторизации и отправки всех неотправленных сообщений
  ///им будет призвоен соответствующий userId.
  MessageSendingState send(int chatId, String text){
    final message = ChatMessageData.create(chatId, text, _userId);
    final tempId = _sendCompleters.length;
    final completer = _sendCompleters[tempId] = Completer<ChatMessageData>();
    _client.send(
      ChatMessageBullet(
        chatId:chatId,
        text: text,
        tempId: tempId,
        dateTime: message.dateTime.millisecondsSinceEpoch
      ),
      true
    );
    return MessageSendingState._create(message, completer.future);
  }
  _onGiveMessage(Json messageJson){
    if(messageJson['type']!=PunchType.chat.name) return;
    ChatMessagePunch message = ChatMessagePunch.fromJson(messageJson['data']);
    if(message.userId == _client.userId){//если прилетело предположительно моё сообщение
      final completer = _sendCompleters[message.tempId];
      if(completer != null){//если я получил свое сообщение
        completer.complete(message.toChatMessage());
        _sendCompleters.remove(message.tempId);
        return;
      }
    }
    onReceived.invoke(message.toChatMessage());
  }
}
class MessageSendingState{
  final ChatMessageData sendedData;
  final Future<ChatMessageData> sendingResult;
  const MessageSendingState._create(this.sendedData, this.sendingResult);
}