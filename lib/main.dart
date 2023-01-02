import 'package:flutter/material.dart';
import 'package:matcha/services/Locator.dart';
import 'package:matcha/env.dart';
import 'package:matcha/router/app_router.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Env.appTitile,
      theme: ThemeData.dark(useMaterial3: true),
      navigatorKey: Locator.navigatorKey,      
      onGenerateRoute:AppRouter.getHandler(
        onGenerateRoute: (route, settings)=>route
      ),
    );
  }
}
