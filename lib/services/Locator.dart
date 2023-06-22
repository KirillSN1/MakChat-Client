import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:matcha/chat/ws_chat_client/ws_chat_client.dart';
import 'package:matcha/models/messages_channel.dart';

class Locator{
  static WSClient get wsClient=>GetIt.instance.get<WSClient>();
  static MessagesChannel get messagesChannel=>GetIt.instance.get<MessagesChannel>();
  static GlobalKey<NavigatorState> get navigationGlobalKey=>GetIt.instance<GlobalKey<NavigatorState>>();
  static void init(){
    GetIt.instance.registerLazySingleton(()=>GlobalKey<NavigatorState>());
    GetIt.instance.registerLazySingleton(() {
      final client = WSClient.connect();
      // client.auth();
      client.onDisconnect.addListener((eventData) { log("ws reconnect...");  client.reconnect(); });
      return client;
    });
    GetIt.instance.registerLazySingleton(() {
      return MessagesChannel.create();
    });
  }
}