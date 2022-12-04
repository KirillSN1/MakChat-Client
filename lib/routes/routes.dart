import 'package:flutter/material.dart';
import 'package:matcha/router/base_route.dart';
import 'package:matcha/routes/args/chat_args.dart';
import 'package:matcha/views/chat_view.dart';
import 'package:matcha/views/login_view.dart';
import 'package:matcha/views/main_view.dart';
import 'package:matcha/views/scaffold/default_app_bar.dart';
import 'args/main_args.dart';

class LoginRoute extends IBaseRoute{
  const LoginRoute();
  @override
  Route build(RouteSettings settings, dynamic arguments) {
    return MaterialPageRoute(builder: (BuildContext context)=>LoginView(), settings: settings);
  }
}

class MainRoute extends IBaseRoute<MainArgs>{
  const MainRoute();
  @override
  Route build(RouteSettings? settings, MainArgs? args) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context)=>MainView(args: args));
  }
}

class ChatRoute extends IBaseRoute<ChatArgs>{
  const ChatRoute();
  @override
  Route build(RouteSettings? settings, ChatArgs? args) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context)=>ChatView(args: args));
  }
}
class LoadingRoute extends IBaseRoute<ChatArgs>{
  const LoadingRoute();
  @override
  Route build(RouteSettings? settings, ChatArgs? args) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context)=>Scaffold(
        appBar: DefaultAppBar(), 
        body: const Center(child: CircularProgressIndicator()),
      )
    );
  }
}
