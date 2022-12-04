import 'package:http/http.dart' as http;
import 'package:matcha/env.dart';

class ConnectionInfoProvider{
  final int? port;
  static ConnectionInfoProvider? _singleton;
  static Future<ConnectionInfoProvider> get() async{
    const path = "/Api/getPort";
    final hostUri = Uri(scheme: Env.scheme, host: Env.host, port: Env.port, path:path);
    final response = await http.get(hostUri);
    final realPort = int.tryParse(response.body);
    return _singleton ?? (_singleton = ConnectionInfoProvider._(realPort));
  }
  const ConnectionInfoProvider._(this.port);
  Uri get apiUri => Uri(host: Env.host, port: port);
  Uri get wsUri => Uri(scheme: Env.wsScheme ,host: Env.host, port: port);
}