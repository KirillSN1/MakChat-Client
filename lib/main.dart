import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:matcha/services/locator.dart';
import 'package:matcha/env.dart';
import 'package:matcha/router/app_router.dart';

void main() async {
  Locator.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Env.appTitile,
      theme: ThemeData.dark(useMaterial3: false),
      navigatorKey: GetIt.instance<GlobalKey<NavigatorState>>(),      
      onGenerateRoute:AppRouter.getHandler(
        onGenerateRoute: (route, settings)=>route
      ),
    );
  }
}
