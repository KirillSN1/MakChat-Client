import 'dart:async';
import 'dart:developer';
import 'package:matcha/chat/ws_chat_client/disconnect_reson.dart';
import 'package:matcha/chat/ws_messages/client/ws_chat_request/ws_chat_request.dart';
import 'package:matcha/chat/ws_messages/client/ws_connect_request/ws_connect_request.dart';
import 'package:matcha/chat/ws_messages/server/ws_chat_message/ws_chat_message.dart';
import 'package:matcha/chat/ws_messages/server/ws_connect_message/ws_connect_message.dart';
import 'package:matcha/chat/ws_messages/ws_message_types.dart';
import 'package:matcha/low/event.dart';
import 'package:matcha/structs/Json.dart';
import '../../services/auth/auth.dart';
import '../../services/json_socket.dart';

class WSChatClient{
  late JsonSocket _socket;
  final onMessage = Event<WSChatMessage>();
  final onConnect = Event<WSConnectMessage>();
  final onDisconnect = Event<DisconnectReson>();
  bool _connected = false;
  bool get connected=>_connected;

  Future connect(int chatId, String token) async {
    _socket = await JsonSocket.connect();
    _socket.onData.addListener(_onData);
    _socket.onDone.addListener(_onDone);
    _socket.listen();
    final message = WSConnectRequest(token:token, chatId:chatId );
    _socket.send(message.toJson());
  }
  Future disconnect() async {
    _socket.onData.removeListener(_onData);
    _socket.onDone.removeListener(_onDone);
    if(_socket.closeCode == null) await _socket.close();
    _connected = false;
  }
  Future disconnectAndNotify() async {
    await disconnect();
    final code = _socket.closeCode??0;
    final reson = _socket.closeReason??"";
    onDisconnect.invoke(DisconnectReson(code, reson));
  }
  ///Sends messages into chat. If disconnected and [collectIfDisconnected] == false, throws Exception;
  ///If [collectIfDisconnected] == true, [message] will send after connect.
  send(WSChatRequest message, [bool collectIfDisconnected = false]){
    if(connected) {
      _socket.send(message.toJson());
    } else if(collectIfDisconnected) {
      onConnect.addListener(once:true,(_)=>send(message,collectIfDisconnected));
    }
  }
  void _onData(Json? json){
    if(json == null) return;
    final type = WSMessageType.fromString(json["type"]??"");
    switch(type){
      case WSMessageType.connection:
        _onConnectResponseMessage(WSConnectMessage.fromJson(json));
        break;
      case WSMessageType.chat:
        _onChatMessage(WSChatMessage.fromJson(json));
        break;
      case WSMessageType.unknown:break;//skip unknown messages
    }
  }
  void _onConnectResponseMessage(WSConnectMessage message){
    if(_connected == message.connected) return;
    if(message.connected) {
      _connected = message.connected;
      onConnect.invoke(message);
    } else {
      disconnectAndNotify();
    }
    _connected = message.connected;
  }
  void _onChatMessage(WSChatMessage message) {
    if(_connected) {
      onMessage.invoke(message);
    } else {
      onConnect.addListener(once:true,(_)=>_onChatMessage(message));
    }
  }
  void _onDone(eventData) {
    disconnectAndNotify();
  }
}