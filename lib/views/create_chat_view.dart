import 'package:flutter/material.dart';
import 'package:matcha/routes/args/chat_args.dart';
import 'package:matcha/services/repositories/auth/auth_info.dart';
import 'package:matcha/services/repositories/errors.dart';
import 'package:matcha/services/repositories/users/user_repository.dart';
import 'package:matcha/views/components/chat_list/chat_card/chat_card.dart';
import '../models/user/user.dart';
import '../routes/app_route_enum.dart';

class CreateChatView extends StatefulWidget{
  final AuthInfo authInfo;
  const CreateChatView({ super.key, required this.authInfo });

  @override
  State<CreateChatView> createState() => _CreateChatViewState();
}
enum SearchingState{
  ready,
  searching,
  error
}
class _CreateChatViewState extends State<CreateChatView> {
  final FocusNode _searchFocusNode = FocusNode();
  List<User> users = [];
  bool _searchActive = false;
  SearchingState _searchingState = SearchingState.ready;

  @override
  void initState() {
    super.initState();
    _onSearchPress();//TODO:открывать поиск, если нет чатов
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: _searchActive//TODO:анимация перехода
            ?Focus(
              onFocusChange: _onSearchFieldFocusChange,
              child: TextField(
                onChanged: _onSearch,
                autofocus: true,
                focusNode: _searchFocusNode,
                decoration: const InputDecoration(
                  hintText: "Поиск",
                  border: InputBorder.none
                ),
              ),
            ):const Text("Новое сообщение"),
          actions: [
            if(!_searchActive)
              IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: _onSearchPress,
                splashRadius: 18,
              )
          ]
        ),
        body: ListView(children: [
          if(_searchingState == SearchingState.error)
            const Center(child:Text("Ошибка сети.")),
          if(_searchingState == SearchingState.searching)
            const Center(child:LinearProgressIndicator()),
          if(_searchingState == SearchingState.ready) ...[
            if(_searchActive && users.isEmpty)
              const Center(child: Text("Пользователи не найдены")),
            ...users.map((user) => 
              ChatCard(
                chatName:user.login,
                onTap: ()=>_onChatTap(user,context),
              )
            ),
          ]
        ]),
      ),
    );
  }

  void _onSearchPress() {
    setState(() { 
      _searchActive = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchFocusNode.requestFocus();
      });
    });
  }
  void _onSearchFieldFocusChange(bool value) {
    if(!value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchFocusNode.requestFocus();
      });
    }
  }
  void _onSearch(String value) async {
    setState(() {
      _searchingState = SearchingState.searching;
    });
    try{
      var result = await UserRepository.search(value);
      setState(() {
        users = result;
        users.removeWhere((user) => user.id == widget.authInfo.user.id);
        _searchingState = SearchingState.ready;
      });
    } on UnhandledRepositoryError {
      _searchingState = SearchingState.error;
      rethrow;
    }
  }
  Future<bool> _onWillPop() async {
    if(_searchActive){
      setState(() {
        _searchActive = false;
      });
      return false;
    }
    return true;
  }
  
  _onChatTap(User user,BuildContext context) {
    final chatArgs = NewSingleChatArgs(authInfo: widget. authInfo, user: user);
    Navigator.of(context).pushReplacement(AppRoute.chat.route.build(chatArgs));
  }
}