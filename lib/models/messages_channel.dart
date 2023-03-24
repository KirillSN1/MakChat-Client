import 'package:get_it/get_it.dart';
import 'package:matcha/chat/ws_chat_client/ws_chat_client.dart';
import 'package:matcha/chat/ws_messages/client/ws_chat_request/ws_chat_request.dart';
import 'package:matcha/chat/ws_messages/server/ws_chat_message/ws_chat_message.dart';
import 'package:matcha/chat/ws_messages/ws_message_types.dart';
import 'package:matcha/low/event.dart';
import 'package:matcha/models/chat_message/chat_message.dart';
import 'package:matcha/models/message_status.dart';
import 'package:matcha/services/Locator.dart';
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
  final AuthInfo authInfo;

  List<MessagesGroup> get messagesGroups=>_messagesGrouper.groups;
  List<ChatMessage> get messages=>_messagesGrouper.messages;
  List<ChatMessage> get messagesInSending=>_messagesInSending;
  
  MessagesChannel._(this.authInfo, this._client){
    _client.onData.addListener(_onGiveMessage);
  }
  static Future<MessagesChannel> create(AuthInfo authInfo) async {
    final client = await GetIt.instance.getAsync<WSClient>();
    return MessagesChannel._(authInfo, client);
  }
  ChatMessage send(int chatId,String text){
    final message = ChatMessage.create(text, authInfo.user.id);
    _messagesGrouper.add(message);
    _messagesInSending.add(message);
    _client.send(
      WSChatRequest(
        text: text, 
        chatId: chatId,
        dateTime: message.dateTime.millisecondsSinceEpoch
      ),
      true
    );
    return message;
  }
  _onGiveMessage(Json data){
    if(data['type']!=WSMessageType.chat.name) return;
    WSChatMessage message = WSChatMessage.fromJson(data);
    ChatMessage chatMessage;
    if(message.appUserId == authInfo.user.id){//если прилетело предположительно моё сообщение
      final chatMessageIndex = _messagesInSending.indexWhere((sm) {
        return sm.dateTime.millisecondsSinceEpoch == message.created_at
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
        DateTime.fromMillisecondsSinceEpoch(message.updated_at),
        message.appUserId,
        MessageStatus.byValue(message.status,MessageStatus.sended),
        message.changed
      );
      _messagesGrouper.add(chatMessage);
      onReceived.invoke(chatMessage);
    }
  }
  _copyFromWSMessage(WSChatMessage from, ChatMessage to){
    to.id = from.id;
    to.status = MessageStatus.byValue(from.status);
    to.dateTime = DateTime.fromMillisecondsSinceEpoch(from.updated_at);
    to.text = from.text;
    to.changed = from.changed;
  }
}