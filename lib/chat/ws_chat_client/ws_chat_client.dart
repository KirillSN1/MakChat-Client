import 'dart:async';
import 'package:matcha/chat/ws_chat_client/disconnect_reson.dart';
import 'package:matcha/chat/ws_chat_client/messages_receiver.dart';
import 'package:matcha/chat/ws_messages/client/ws_chat_request/chat_message_bullet.dart';
import 'package:matcha/chat/ws_messages/client/ws_connect_request/ws_connect_request.dart';
import 'package:matcha/chat/ws_messages/ws_message_types.dart';
import 'package:matcha/low/event.dart';
import 'package:matcha/structs/json.dart';
import '../../services/json_socket.dart';

class WSClient{
  final JsonSocket _socket;
  final MessageReceiver receiver;
  final onAuth = NullableEvent<int>();
  final onConnect = NullableEvent();
  final onDisconnect = NullableEvent<DisconnectReson>();
  int _userId = 0;
  bool _connected = false;
  int get userId=>_userId;
  bool get authorized=>_connected && _userId>0;
  bool get connected=>_connected;
  Event<Json> get onData => _socket.onData;

  WSClient._(this._socket):receiver = MessageReceiver(_socket.onData){
    receiver.addListener(PunchType.connection.name, _updateAuthorization);
    _socket.onDone.addListener(_onDone);
    _socket.listen();
    _connected = true;
    onConnect.invoke();
  }
  static Future<WSClient> connect() async {
    return WSClient._(await JsonSocket.connect());
  }
  ///Возвращает userId, в случае успеха
  Future<int> auth(String token) async {
    final completer = Completer<int>();
    if(_connected){
      final message = WSConnectRequest(token:token);
      receiver.addListener(once:true,PunchType.connection.name, (message) {
        _updateAuthorization(message);
        completer.complete(_userId);
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
    _userId = 0;
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
  send(ChatMessageBullet message, [bool collectIfUnauthorized = false]){
    if(authorized) {
      _socket.send(message.toJson());
    } else if(collectIfUnauthorized) {
      onAuth.addListener(once:true,(_)=>send(message,collectIfUnauthorized));
    }
  }
  void _updateAuthorization(Json message){
    int newUserId = message['data']??0;
    if(_userId == newUserId) return;
    _userId = newUserId;
    if(newUserId>0) {
      onAuth.invoke(_userId);
    } else {
      disconnectAndNotify();
    }
  }
  void _onDone(eventData) {
    disconnectAndNotify();
  }
}