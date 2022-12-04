import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matcha/env.dart';
import 'package:matcha/services/auth/auth.dart';
import 'package:matcha/models/user.dart';
import 'package:matcha/routes/args/main_args.dart';
import 'package:matcha/services/repositories/auth/auth_errors.dart';
import '../routes/app_route_enum.dart';

class LoginView extends StatefulWidget{

  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  String? _login;
  String? _password;
  
  bool _isLoading = false;

  @override
  initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
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
                    // ElevatedButton(
                    //   key: ,
                    //   onPressed: ()=>_onLogin(context),
                    //   child: const Text("Вход"),
                    // )
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
    await _signInOrUp(context);
    setState(() {
      _isLoading = false;
    });
  }
  _signInOrUp(context) async {
    
    final form = _formKey.currentState;
    if(form!.validate()) {
      form.save();
      final login = _login ?? "";
      final password = _password ?? "";
      try {
        final result = await Auth.signUp(login,password);
        switch(result){
          case SignUpResult.success:break;
          case SignUpResult.alreadyExists:{
            final signResult = await Auth.signIn(login, password);
            if(signResult == SignInResult.incorrectPassword) {
              return _showSnackMessage(context, "Логин или пароль неверный");
            }
          }
        }
        _showSnackMessage(context, "Здравствуйте, $login");
        _onLogined(context,User(login: login));
      }
      on AuthError catch (error){
        _showSnackMessage(context, error.message);
      }
    }
  }
  void _onLogined(BuildContext context, User user) {
    
    Navigator.of(context).push(
      AppRoute.main.route.build(null, MainArgs(user))
    );
  }
  void _showSnackMessage(context,String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
  
}