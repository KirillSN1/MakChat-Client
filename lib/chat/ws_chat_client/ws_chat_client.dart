import 'dart:async';
import 'dart:developer';
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
  final onDisconnect = NullableEvent<DisconnectReson>();
  final onAuthError = NullableEvent();
  int _userId = 0;
  String _lastToken = "";
  int get userId=>_userId;
  bool get authorized=>_userId>0;
  Event<Json> get onData => _socket.onData;

  WSClient._(this._socket):receiver = MessageReceiver(_socket.onData){
    receiver.addListener(PunchType.connection.name, _updateAuthorization);
    onAuth.addListener(_onAuth);
    _socket.listen();
  }
  static WSClient connect() {
    return WSClient._(JsonSocket.connect());
  }
  Future<int> auth([String? token]) async {
    var completer = Completer<int>();
    _lastToken = token = token ?? _lastToken;
    final message = WSConnectRequest(token:token);
    authCallback(Json message) {
      if(completer.isCompleted) return;
      _updateAuthorization(message);
      completer.complete(_userId);
    }
    closeCallback(_){
      if(completer.isCompleted) return;
      completer.completeError(Exception("Soket closed."));
    }
    receiver.addListener(once: true, PunchType.connection.name, authCallback);
    _socket.onDone.addListener(once: true, closeCallback);
    _socket.send(message.toJson());
    return completer.future;
  }
  Future disconnect() async {
    if(_socket.closeCode == null) _socket.close();
    _userId = 0;
  }
  dispose(){
    receiver.dispose();
    _socket.onDone.removeListener(_onDone);
    disconnect();
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
  Future<int> reconnect() async {
    log("WSClient: try reconnect...");
    try{
      _socket..connect()..listen();
      return await auth();
    } catch (e){
      return reconnect();
    }
  }
  void _onAuth(int? eventData) {
    log(authorized?"authorized":"authorization rejected");
    if(!authorized) onAuthError.invoke();
    _socket.onDone.addListener(_onDone,once: true);
  }
  void _onDone(eventData) {
    log("done");
    disconnectAndNotify();
  }
}