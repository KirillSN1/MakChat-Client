import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matcha/services/auth/jwt_payload.dart';

class AuthToken{
  static const _tokenProperty = "auth_token";
  static AuthToken? _token;
  final String value;
  late final JWTPayload _payload;

  JWTPayload get payload => _payload;
  DateTime get exp => DateTime.fromMillisecondsSinceEpoch(payload.exp*1000);
  bool get isActual=>exp.isAfter(DateTime.now());
  
  AuthToken.fromJWT(this.value){
    final parts = value.split(".");
    if(parts.length!=3) throw AuthTokenInvalidStringError("Token must consists of 3 part with \".\" separator");
    // final jsonString = AsciiDecoder().convert(parts[0].codeUnits);
    // log(jsonString);
    final payloadJson = json.decode(ascii.decode(base64Url.decode(base64Url.normalize(parts[1]))));
    _payload = JWTPayload.fromJson(payloadJson);
    // if(DateTime.fromMillisecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {
    //   log("logined");
    // } else {
    //   log("unlogined");
    // }
  }
  static Future<AuthToken?> get() async {
    if(_token != null) return _token!;
    const secureStorage = FlutterSecureStorage();
    final token = await secureStorage.read(key: _tokenProperty);
    if(token == null) return null;
    try{
      return _token = AuthToken.fromJWT(token);
    } catch (e){
      return null;
    }
  }
  static Future set(AuthToken token) {
    const secureStorage = FlutterSecureStorage();
    return secureStorage.write(key: _tokenProperty, value: token.value);    
  }
}
class AuthTokenInvalidStringError implements Exception {
  final String message;
  AuthTokenInvalidStringError(this.message);
}