class User{
  int id;
  String login;
  User({this.id = 0, this.login = ""});

  factory User.jsonParse(Map<String, dynamic> json){
    return User(id: json["id"], login: json["login"]);
  }
}