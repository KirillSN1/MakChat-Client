import 'package:flutter/cupertino.dart';
import 'package:matcha/routes/not_found_route.dart';
import 'package:matcha/routes/app_route_enum.dart';

typedef OnGenerateRoute = AppRoute Function(AppRoute route, RouteSettings settings);
class AppRouter{
  OnGenerateRoute onGenerateRoute;
  AppRouter._({ required this.onGenerateRoute });
  Route _onGenerateRoute(RouteSettings settings){
    try{
      String name = settings.name ?? AppRoute.notFound.name;
      var routeData = onGenerateRoute(AppRoute.byName(name), settings);
      return routeData.route.build(settings, null);
    } catch(e){
      return const NotFoundRoute().build(settings, null);
    }
  }
  static Route Function(RouteSettings s) getHandler({ required OnGenerateRoute onGenerateRoute }){
    return AppRouter._(onGenerateRoute: onGenerateRoute)._onGenerateRoute;
  }
}