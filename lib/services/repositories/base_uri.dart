import '../../env.dart';

class BaseUri{
  static Uri getWith({ 
      String? path, 
      Map<String, dynamic>? queryParameters,
      String? fragment,
      Iterable<String>? pathSegments,
      String? query,
      String? userInfo
    }){
    return Uri(
      scheme: Env.scheme, 
      host: Env.host, 
      port: Env.port,
      path: path,
      queryParameters: queryParameters,
      fragment: fragment,
      pathSegments: pathSegments,
      query: query,
      userInfo: userInfo
    );
  }
  BaseUri._();
}