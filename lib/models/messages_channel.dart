import 'package:matcha/chat/ws_chat_client/ws_chat_client.dart';
import 'package:matcha/chat/ws_messages/client/ws_chat_request/ws_chat_request.dart';
import 'package:matcha/chat/ws_messages/server/ws_chat_message/ws_chat_message.dart';
import 'package:matcha/low/event.dart';
import 'package:matcha/models/chat_message/chat_message.dart';
import 'package:matcha/models/message_status.dart';
import 'package:matcha/services/repositories/auth/auth_info.dart';
import 'messages_groups_list.dart';

class MessagesChannel{
  final WSChatClient _client = WSChatClient();
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
  
  MessagesChannel(this.authInfo);
  Future connect(int chatId) async {
    _client.onMessage.addListener(_onGiveMessage);
    await _client.connect(chatId, authInfo.token);
  }
  disconnect(){
    _client.disconnect();
  }
  ChatMessage send(String text){
    final message = ChatMessage.create(text, authInfo.user.id);
    _messagesGrouper.add(message);
    _messagesInSending.add(message);
    _client.send(
      WSChatRequest(
        text: text, 
        dateTime: message.dateTime.millisecondsSinceEpoch
      ),
      true
    );
    return message;
  }
  _onGiveMessage(WSChatMessage? message){
    if(message == null) return;
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

    // setState(() {
      // final messageDateTime = DateTime.fromMillisecondsSinceEpoch(message.updated_at);
      // final groupKey = MessagesGroupKey.from(message.id,message.appUserId, messageDateTime);
      // final messageGroup = _messagesGrouper.groups[groupKey];
      // final chatMessageIndex = messageGroup==null?-1:messageGroup.indexWhere(
      //   (m)=>m.id == message.id ||
      //     m.id == 0 &&
      //     m.authorId == message.appUserId &&
      //     m.text == message.text &&
      //     m.dateTime.millisecondsSinceEpoch == message.created_at);
      // if(messageGroup != null && chatMessageIndex >= 0){
      //   final chatMessage = messageGroup[chatMessageIndex];
      //   if(chatMessage.id == message.id){
      //     chatMessage.text = message.text;
      //     chatMessage.changed = message.changed;
      //     chatMessage.dateTime = DateTime.fromMillisecondsSinceEpoch(message.updated_at);
      //   }
      //   if(chatMessage.id == ChatMessage.defaultId) chatMessage.id = message.id;
      //   chatMessage.status = MessageStatus.byValue(message.status,MessageStatus.sended);
      // }
      // else{
      //   final scrollPixels = _scrollController.position.pixels;
      //   final maxScrollExtent = _scrollController.position.maxScrollExtent;
      //   _pushMessage(ChatMessage(
      //     message.id,
      //     message.text,
      //     DateTime.fromMillisecondsSinceEpoch(message.updated_at),
      //     message.appUserId,
      //     MessageStatus.byValue(message.status,MessageStatus.sended),
      //     message.changed
      //   ),animate: scrollPixels == maxScrollExtent);
      // }
    // });
  }
  _copyFromWSMessage(WSChatMessage from, ChatMessage to){
    to.id = from.id;
    to.status = MessageStatus.byValue(from.status);
    to.dateTime = DateTime.fromMillisecondsSinceEpoch(from.updated_at);
    to.text = from.text;
    to.changed = from.changed;
  }
}