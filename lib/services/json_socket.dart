import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:matcha/low/event.dart';
import 'package:matcha/services/connector.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class JsonSocket{
  late final WebSocketChannel _channel;
  final onData = NullableEvent<Map<String,dynamic>>();
  final onError = NullableEvent();
  final onDone = NullableEvent();
  JsonSocket(this._channel);
  static Future<JsonSocket> connect() async {
    final channel = await Connector.connect();
    return JsonSocket(channel);
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