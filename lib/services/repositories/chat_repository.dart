import 'dart:convert';

import 'package:matcha/env.dart';
import 'package:matcha/models/chat/chat.dart';
import 'package:matcha/models/chats_search_result/chats_search_result.dart';
import 'package:matcha/models/user/user.dart';
import 'package:matcha/services/auth/auth.dart';
import 'package:matcha/services/repositories/auth/auth_errors.dart';
import 'package:matcha/services/repositories/auth/auth_info.dart';
import 'package:http/http.dart' as http ;
import 'package:matcha/services/repositories/base_uri.dart';
import 'package:matcha/services/repositories/errors.dart';

class ChatRepository{
  ///создает чат с одним пользователем
  static Future<Chat?> create(AuthInfo authInfo, List<int> users) async {
    final url = BaseUri.getWith(path: "/Api/createChat");
    final response = await http.post(url, body: <String,String>{
      "token":authInfo.token,
      "userIds":jsonEncode(users),
    });
    final message = response.reasonPhrase?? response.body;
    switch(response.statusCode){
      case 200:break;
      case 401:
        if(Env.debug) throw IncorrectPasswordOrTokenError(message);
        return null;
      case 422:
        if(Env.debug) throw RequestArgumentsError(message);
        return null;
      case 404:
        if(Env.debug) throw RequestNotFoundError(message);
        return null;
      default:
        throw UnhandledRepositoryError(message);
    }
    return Chat.fromJson(jsonDecode(response.body));
  }
  static Future<Iterable<Chat>> getUserChats(AuthInfo authInfo) async {
    final url = BaseUri.getWith(path: "/Api/getUserChats", 
      queryParameters: { "token":authInfo.token });
    final response = await http.get(url);
    final message = response.reasonPhrase?? response.body;
    switch(response.statusCode){
      case 200:break;
      case 401:
        if(Env.debug) throw IncorrectPasswordOrTokenError(message);
        return [];
      case 422:
        if(Env.debug) throw RequestArgumentsError(message);
        return [];
      case 404:
        if(Env.debug) throw RequestNotFoundError(message);
        return [];
      default:
        throw UnhandledRepositoryError(message);
    }
    final chatsList = jsonDecode(response.body) as List;
    return chatsList.map((e) => Chat.fromJson(e));
  }
  static Future<ChatsSearchResult> search(String value) async {    
    var response = await http.get(BaseUri.getWith(
      path: "/Api/findChats", 
      queryParameters: { "search":value })
    );
    var body = response.body;
    switch(response.statusCode){
      case(200):break;
      default:throw UnhandledRepositoryError(response.body);
    }
    return ChatsSearchResult.fromJson(jsonDecode(body));
    // return users.map((e) => Chat.fromJson(e as Map<String, dynamic>)).toList();
  }
}