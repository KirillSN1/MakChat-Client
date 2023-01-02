import 'dart:async';

import 'package:flutter/material.dart';
import 'package:matcha/env.dart';
import 'package:matcha/routes/app_route_enum.dart';
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
    Auth.signedIn().then((value) {
      if(value != null){
        Navigator.pushReplacement(context, AppRoute.main.route.build(value));
      }
      else{
        Navigator.pushReplacement(context, AppRoute.login.route.build(null));
      }
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