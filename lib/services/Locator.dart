import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:matcha/chat/ws_chat_client/ws_chat_client.dart';

class Locator{
  static Future<WSClient> get wsClient=>GetIt.instance.getAsync<WSClient>();
  static GlobalKey<NavigatorState> get navigationGlobalKey=>GetIt.instance<GlobalKey<NavigatorState>>();
  static void init(){
    GetIt.instance.registerLazySingleton(()=>GlobalKey<NavigatorState>());
    GetIt.instance.registerLazySingletonAsync(() => WSClient.connect());
  }
}