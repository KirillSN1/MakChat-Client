import 'dart:convert';

import 'package:matcha/env.dart';
import 'package:matcha/models/chat_message/chat_message.dart';
import 'package:matcha/services/repositories/auth/auth_errors.dart';
import 'package:matcha/services/repositories/auth/auth_info.dart';
import 'package:http/http.dart' as http ;
import 'package:matcha/services/repositories/base_uri.dart';
import 'package:matcha/services/repositories/errors.dart';

import '../../chat/ws_messages/server/chat_message_punch/chat_message_punch.dart';

class MessagesRepository{
  
  static Future<Iterable<ChatMessage>> getMessagesHystory(AuthInfo authInfo, int chatId) async {
    final url = BaseUri.getWith(path: "/Api/getMessagesHystory");
    final response = await http.post(url, body: { "token":authInfo.token, "chatId":chatId.toString() });
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
    final messagesList = jsonDecode(response.body) as List;
    return messagesList.map((e) => ChatMessagePunch.fromJson(e).toChatMessage());
  }
}