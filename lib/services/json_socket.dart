import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:matcha/low/event.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../env.dart';

class JsonSocket{
  late WebSocketChannel _channel;
  final onData = Event<Map<String,dynamic>>();
  final onError = NullableEvent();
  final onDone = NullableEvent();
  JsonSocket.connect() { connect(); }
  void connect(){
    final uri = Uri(scheme: Env.wsScheme, host: Env.host, port: Env.port);
    _channel = WebSocketChannel.connect(uri);
  }
  void send(Map<String, dynamic> json){
    _channel.sink.add(jsonEncode(json));
  }
  StreamSubscription listen([bool cancelOnError = false]){
    return _channel.stream.listen(_onData,
      onError: onError.invoke,
      onDone: onDone.invoke,
      cancelOnError: cancelOnError
    );
  }
  Future close([int? closeCode, String? closeReason])=>_channel.sink.close(closeCode, closeReason);
  int? get closeCode => _channel.closeCode;
  String? get closeReason => _channel.closeReason;
  String? get protocol => _channel.protocol;
  _onData(dynamic event){
    log(event.toString());
    if(event is! String) return;
    final message  = jsonDecode(event);
    onData.invoke(message);
  }
}