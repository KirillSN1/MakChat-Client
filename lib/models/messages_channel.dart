import 'package:get_it/get_it.dart';
import 'package:matcha/chat/ws_chat_client/ws_chat_client.dart';
import 'package:matcha/chat/ws_messages/client/ws_chat_request/chat_message_bullet.dart';
import 'package:matcha/chat/ws_messages/server/chat_message_punch/chat_message_punch.dart';
import 'package:matcha/chat/ws_messages/ws_message_types.dart';
import 'package:matcha/low/event.dart';
import 'package:matcha/models/chat_message/chat_message.dart';
import '../structs/json.dart';

class SendedMessageEventData{
  ChatMessage sended;
  ChatMessage recirved;
  SendedMessageEventData(this.sended,this.recirved);
}
class MessagesChannel{
  final WSClient _client;
  late final onDisconnect = _client.onDisconnect;
  late final onAuthError = _client.onAuthError;
  final onSended = Event<SendedMessageEventData>();
  final onReceived = Event<ChatMessage>();
  final List<ChatMessage> _messagesInSending = [];
  final int _userId;
  List<ChatMessage> get messagesInSending=>_messagesInSending;
  
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
  ///Возвращает объект [ChatMessage].
  ///Если клинтнт не подключен или не авторизован [ChatMessage.userId]
  ///будет присвоено значение 0.
  ///После авторизации и отправки всех неотправленных сообщений
  ///им будет призвоен соответствующий userId.
  ChatMessage send(int chatId, String text){
    final message = ChatMessage.create(chatId, text, _userId);
    // _messagesGrouper.add(message);
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
    if(message.userId == _client.userId){//если прилетело предположительно моё сообщение
      final chatMessageIndex = _messagesInSending.indexWhere((sm) {
        return sm.dateTime.millisecondsSinceEpoch == message.createdAt
          && sm.text == message.text;
      });
      if(chatMessageIndex>=0){//если я получил свое сообщение
        final sendedMessage = _messagesInSending[chatMessageIndex];
        _messagesInSending.remove(sendedMessage);
        onSended.invoke(SendedMessageEventData(sendedMessage, message.toChatMessage()));
        return;
      }
    }
    onReceived.invoke(message.toChatMessage());
  }
}