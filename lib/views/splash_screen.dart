import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:matcha/chat/ws_chat_client/ws_chat_client.dart';
import 'package:matcha/env.dart';
import 'package:matcha/routes/app_route_enum.dart';
import 'package:matcha/routes/routes.dart';
import 'package:matcha/services/repositories/errors.dart';

import '../services/auth/auth.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _errorMessage = "";
  
  @override
  void initState() {
    super.initState();
    _tryLogin();
  }
  _tryLogin(){
    setState(() {
      _errorMessage = "";
    });
    Auth.signedIn().then((value) async {
      Route route;
      if(value != null){
        final client = await GetIt.instance.getAsync<WSClient>();
        client.auth(value.token);
        final args = MainArguments(value);
        route = AppRoute.main.route.build(args);
      }
      else{
        route = AppRoute.login.route.build(null);
      }
      Navigator.pushReplacement(context, route);
    }).catchError((Object e){
      setState((){
        if(e.runtimeType == RepositoryError){
          final error = e as RepositoryError;
          _errorMessage = "Ошибка подключения";
          _errorMessage+=Env.debug?error.message:".";
        }
        else {
          _errorMessage = "Ошибка.";
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _errorMessage.isEmpty
        ?const Center(child: Text("LOADING"))
        :Center(child: 
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage),
              TextButton(onPressed: ()=>_tryLogin(), child: const Text("Повторить"))
            ]
          )
        )
    );
  }
}