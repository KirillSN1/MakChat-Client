import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:matcha/routes/app_route_enum.dart';
import 'package:matcha/services/auth/auth.dart';
import 'package:matcha/env.dart';
import 'package:matcha/router/app_router.dart';

bool logined = false;
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  logined = await Auth.signedIn();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Env.appTitile,
      theme: ThemeData.dark(),        
      onGenerateRoute:AppRouter.getHandler(
        onGenerateRoute: (route, settings)=>logined?route:AppRoute.login
      ),
    );
  }
}
