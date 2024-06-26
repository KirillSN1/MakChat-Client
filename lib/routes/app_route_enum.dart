import 'package:matcha/router/base_route.dart';
import 'package:matcha/routes/not_found_route.dart';
import 'package:matcha/routes/routes.dart';

enum AppRoute<T extends IBaseRoute>{
  notFound("/not_found", NotFoundRoute()),
  splashScreen("/", SplashScreenRoute()),
  main("/main", MainRoute()),
  chatsList("/chats_list", MainRoute()),
  login("/login", LoginRoute()),
  profile("/profile", ProfileRoute()),
  chat("/chat", ChatRoute()),
  createChat("/createChat", CreateChatRoute()),
  loading("_loading", LoadingRoute());
  final String name;
  final T route;
  const AppRoute(this.name, this.route);
  static byName(name){
    return AppRoute.values.firstWhere((element) => element.name == name);
  }
}