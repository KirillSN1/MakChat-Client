import 'package:flutter/material.dart';
import 'package:matcha/router/base_route.dart';

class NotFoundRoute extends IBaseRoute{
  const NotFoundRoute();
  @override
  Route build(RouteSettings settings, dynamic arguments) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context){
        return const Scaffold(body: Center(child: Text("This page not found.")));
      }
    );
  }
}