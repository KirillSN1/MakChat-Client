import 'package:matcha/env.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Connector{
  static Future<WebSocketChannel> connect() async {
    final uri = Uri(scheme: Env.wsScheme, host: Env.host, port: Env.port);
    print("Cornnection to ${uri}...");
    return WebSocketChannel.connect(uri);
  }
}