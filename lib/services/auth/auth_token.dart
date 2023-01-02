import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matcha/services/auth/jwt_payload.dart';

class AuthToken{
  static const _tokenProperty = "auth_token";
  final String value;
  late final JWTPayload _payload;

  JWTPayload get payload => _payload;
  DateTime get exp => DateTime.fromMillisecondsSinceEpoch(payload.exp*1000);
  bool get isActual=>exp.isAfter(DateTime.now());
  
  AuthToken.fromJWT(this.value){
    final parts = value.split(".");
    if(parts.length!=3) throw AuthTokenInvalidStringError("Token must consists of 3 part with \".\" separator");
    final payloadJson = json.decode(ascii.decode(base64Url.decode(base64Url.normalize(parts[1]))));
    _payload = JWTPayload.fromJson(payloadJson);
  }
  static Future<AuthToken?> get() async {
    const secureStorage = FlutterSecureStorage();
    final tokenRaw = await secureStorage.read(key: _tokenProperty);
    if(tokenRaw == null) return null;
    try{
      return AuthToken.fromJWT(tokenRaw);
    } catch (e){
      return null;
    }
  }
  static Future save(AuthToken token) async {
    const secureStorage = FlutterSecureStorage();
    return secureStorage.write(key: _tokenProperty, value: token.value);    
  }
  static Future remove() async {
    const secureStorage = FlutterSecureStorage();
    return secureStorage.delete(key: _tokenProperty);   
  }
}
class AuthTokenInvalidStringError implements Exception {
  final String message;
  AuthTokenInvalidStringError(this.message);
}