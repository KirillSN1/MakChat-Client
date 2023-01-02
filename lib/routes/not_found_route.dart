import 'package:flutter/material.dart';
import 'package:matcha/router/base_route.dart';

class NotFoundRoute extends IBaseRoute{
  const NotFoundRoute();
  @override
  Route build(dynamic arguments, { RouteSettings? settings }) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context){
        return const Scaffold(body: Center(child: Text("This page not found.")));
      }
    );
  }
}