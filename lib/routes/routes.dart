import 'package:flutter/material.dart';
import 'package:matcha/router/base_route.dart';
import 'package:matcha/routes/args/chat_args.dart';
import 'package:matcha/services/repositories/auth/auth_info.dart';
import 'package:matcha/views/chat_view.dart';
import 'package:matcha/views/components/profile_view.dart';
import 'package:matcha/views/create_chat_view.dart';
import 'package:matcha/views/login_view.dart';
import 'package:matcha/views/main_view.dart';
import 'package:matcha/views/scaffold/default_app_bar.dart';
import 'package:matcha/views/splash_screen.dart';

class SplashScreenRoute extends IBaseRoute{
  const SplashScreenRoute();
  @override
  Route build(arguments,{RouteSettings? settings}) {
    return MaterialPageRoute(
      builder: (BuildContext context)=>const SplashScreen()
    );
  }
}

class LoginRoute extends IBaseRoute{
  const LoginRoute();
  @override
  Route build(dynamic arguments,{RouteSettings? settings}) {
    return MaterialPageRoute(builder: (BuildContext context)=>
      const LoginView(), settings: settings);
  }
}

class ProfileRoute extends IBaseRoute<AuthInfo>{
  const ProfileRoute();
  @override
  Route build(AuthInfo arguments,{RouteSettings? settings}) {
    return MaterialPageRoute(builder: (BuildContext context)=>
      ProfileView(authInfo: arguments), settings: settings);
  }
}

class MainRoute extends IBaseRoute<AuthInfo>{
  const MainRoute();
  @override
  Route build(AuthInfo args,{RouteSettings? settings}) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context)=>MainView(args: args));
  }
}

class ChatRoute extends IBaseRoute<ChatArgs>{
  const ChatRoute();
  @override
  Route build(ChatArgs args,{RouteSettings? settings}) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context)=>ChatView(args: args));
  }
}
class LoadingRoute extends IBaseRoute<ChatArgs>{
  const LoadingRoute();
  @override
  Route build(ChatArgs? args,{RouteSettings? settings}) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context)=>Scaffold(
        appBar: DefaultAppBar(), 
        body: const Center(child: CircularProgressIndicator()),
      )
    );
  }
}
class CreateChatRoute extends IBaseRoute{
  const CreateChatRoute();
  @override
  Route build(arguments,{RouteSettings? settings}) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context)=>const CreateChatView()
    );
  }
}
