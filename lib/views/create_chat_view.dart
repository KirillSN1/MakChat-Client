import 'package:flutter/material.dart';
import 'package:matcha/models/chat.dart';
import 'package:matcha/routes/args/chat_args.dart';
import 'package:matcha/services/repositories/users/user_repository.dart';
import 'package:matcha/views/components/chat_list/chat_card/chat_card.dart';

import '../models/user/user.dart';
import '../routes/app_route_enum.dart';

class CreateChatView extends StatefulWidget{

  const CreateChatView({ super.key});

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
                user.login,
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
    var result = await UserRepository.search(value);
    setState(() {
      users = result;
      _searchingState = SearchingState.ready;
    });
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
    // Navigator.of(context).push(AppRoute.chat.route.build(null, ChatArgs(user: user)));
  }
}