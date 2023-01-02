import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:matcha/services/repositories/base_uri.dart';
import 'package:matcha/services/repositories/errors.dart';
import '../../../models/user/user.dart';
class UserRepository{
  static Future<List<User>> search(String value) async {    
    var response = await http.get(BaseUri.getWith(
      path: "/Api/getChats", 
      queryParameters: { "search":value })
    );
    var body = response.body;
    switch(response.statusCode){
      case(200):break;
      default:throw UnhandledRepositoryError(response.body);
    }
    var users = jsonDecode(body) as List;
    return users.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
  }
}