import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:matcha/chat/ws_chat_client/ws_chat_client.dart';
import 'package:matcha/env.dart';
import 'package:matcha/routes/routes.dart';
import 'package:matcha/services/locator.dart';
import 'package:matcha/services/auth/auth.dart';
import 'package:matcha/models/user/user.dart';
import 'package:matcha/services/repositories/auth/auth_errors.dart';
import 'package:matcha/services/repositories/auth/auth_info.dart';
import 'package:matcha/services/repositories/errors.dart';
import '../routes/app_route_enum.dart';

class LoginView extends StatefulWidget{

  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _loginTextController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  String? _login;
  String? _password;
  
  bool _isLoading = false;
  

  @override
  initState(){
    super.initState();
    Auth.lastUser.then((value) => _setLogin(value?.login));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
  }
  _setLogin(String? login){
    if(login == null || login.isEmpty) return;
    setState(() {
      _login = login;
      _loginTextController.text = _login!;
      _passwordFocusNode.requestFocus();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: Text(Env.appTitile, style: TextStyle(fontSize:36)),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        controller: _loginTextController,
                        autofocus: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder().copyWith(
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                          ),
                          labelText: "Имя пользователя"
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if(value==null || value.length < 5) return "Минимум 5 символов.";
                          return null;
                        },
                        onSaved: (newValue) => _login = newValue,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        focusNode: _passwordFocusNode,
                        autofocus: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder().copyWith(
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                          ),
                          labelText: "Пароль"
                        ),
                        validator: (value) {
                          if(value==null || value.length < 8) return "Минимум 8 символов.";
                          return null;
                        },
                        onSaved: (newValue) => _password = newValue,
                      ),
                    ),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(300)
                        )
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _onSubmit,
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16.0)),
                        icon: _isLoading
                            ? Container(
                                width: 24,
                                height: 24,
                                padding: const EdgeInsets.all(2.0),
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Icon(Icons.login_rounded),
                        label: const Text('Вход'),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  _onSubmit() async {
    setState(() {
      _isLoading = true;
    });
    await _signInOrUp();
    setState(() {
      _isLoading = false;
    });
  }
  _signInOrUp() async {
    final form = _formKey.currentState;
    if(form!.validate()) {
      form.save();
      final login = _login ?? "";
      final password = _password ?? "";
      try{
        final result = await Auth.signIn(login,password);
        return _onLogined(result);
      } on IncorrectPasswordOrTokenError{
        return _showSnackMessage(context, "Логин или пароль неверный.");
      } on UserNotExistsError{
        return _register(login, password);
      } on UnhandledRepositoryError catch(error){
        _showSnackMessage(context, "Ошибка подключения:${error.message}");
      }
      catch(error){
        _showSnackMessage(context, "Ошибка${Env.debug?":$error":""}.");
      }
    }
  }
  _register(String login, String password) async{
    try{
      final result = await Auth.signUp(login,password);
      _onLogined(result);
      return;
    } on UserAlreadyExistsError{
      return _showSnackMessage(context, "Пользователь уже существует.");
    } on UnhandledRepositoryError catch(error){
      _showSnackMessage(context, "Ошибка подключения:${error.message}");
    }
    catch(error){
      _showSnackMessage(context, "Ошибка${Env.debug?":$error":""}.");
    }
  }
  void _onLogined(AuthInfo authInfo) {
    final args = MainArguments(authInfo);
    final client = GetIt.instance.get<WSClient>();
    client.auth(authInfo.token);
    Navigator.of(context).push(AppRoute.main.route.build(args));
  }
  void _showSnackMessage(context,String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  } 
}