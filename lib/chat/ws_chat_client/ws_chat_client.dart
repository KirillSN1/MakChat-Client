import 'dart:async';
import 'dart:developer';
import 'package:matcha/chat/ws_chat_client/disconnect_reson.dart';
import 'package:matcha/chat/ws_chat_client/messages_receiver.dart';
import 'package:matcha/chat/ws_messages/client/ws_chat_request/ws_chat_request.dart';
import 'package:matcha/chat/ws_messages/client/ws_connect_request/ws_connect_request.dart';
import 'package:matcha/chat/ws_messages/ws_message_types.dart';
import 'package:matcha/low/event.dart';
import 'package:matcha/structs/json.dart';
import '../../services/json_socket.dart';

class WSClient{
  final JsonSocket _socket;
  final MessageReceiver receiver;
  final onAuth = NullableEvent<bool>();
  final onConnect = NullableEvent();
  final onDisconnect = NullableEvent<DisconnectReson>();
  bool _authorized = false;
  bool _connected = false;
  bool get authorized=>_connected && _authorized;
  bool get connected=>_connected;
  Event<Json> get onData => _socket.onData;

  WSClient._(this._socket):receiver = MessageReceiver(_socket.onData){
    receiver.addListener(WSMessageType.connection.name, _onAuth);
    _socket.onDone.addListener(_onDone);
    _socket.listen();
    _connected = true;
    onConnect.invoke();
  }
  static Future<WSClient> connect() async {
    return WSClient._(await JsonSocket.connect());
  }
  Future<bool> auth(String token) async {
    final completer = Completer<bool>();
    if(_connected){
      final message = WSConnectRequest(token:token);
      receiver.addListener(once:true,WSMessageType.connection.name, (message) {
        _onAuth(message);
        completer.complete(_authorized);
      });
      _socket.send(message.toJson());
    } else{
      onConnect.addListener(once: true, (_) async =>{ completer.complete(await auth(token)) });
    }
    return completer.future;
  }
  Future disconnect() async {
    receiver.dispose();
    _socket.onDone.removeListener(_onDone);
    if(_socket.closeCode == null) await _socket.close();
    _authorized = false;
    _connected = false;
  }
  Future disconnectAndNotify() async {
    await disconnect();
    final code = _socket.closeCode??0;
    final reson = _socket.closeReason??"";
    onDisconnect.invoke(DisconnectReson(code, reson));
  }
  ///Sends messages into chat. If disconnected or unauthorized and [collectIfUnauthorized] == false,
  ///throws Exception;
  ///If [collectIfUnauthorized] == true, [message] will send after connect and unauthorize.
  send(WSChatRequest message, [bool collectIfUnauthorized = false]){
    if(authorized) {
      _socket.send(message.toJson());
    } else if(collectIfUnauthorized) {
      onAuth.addListener(once:true,(_)=>send(message,collectIfUnauthorized));
    }
  }
  void _onAuth(Json message){
    final authorized = message['connected']??false;
    if(_authorized == authorized) return;
    if(authorized) {
      _authorized = authorized;
      onAuth.invoke(authorized);
    } else {
      disconnectAndNotify();
    }
    _authorized = authorized;
  }
  void _onDone(eventData) {
    disconnectAndNotify();
  }
}