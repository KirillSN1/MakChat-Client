import 'package:flutter/material.dart';
import 'package:matcha/chat/ws_chat_client/disconnect_reson.dart';
import 'package:matcha/env.dart';
import 'package:matcha/models/chat_message/chat_message.dart';
import 'package:matcha/models/messages_channel.dart';
import 'package:matcha/routes/args/chat_args.dart';
import 'package:matcha/views/components/chat/chat_app_bar.dart';
import 'package:matcha/views/components/chat/chat_text_field.dart';
import 'package:matcha/views/components/chat/default_message_group_view.dart';

enum ChatViewState{
  loading, loaded, errored
}

class ChatView extends StatefulWidget{
  final ChatArgs args;
  const ChatView({super.key, required this.args });
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with TickerProviderStateMixin {
  late final MessagesChannel _messagesChannel = MessagesChannel(widget.args.authInfo);
  late ChatViewState _state;
  final _inputContriller = TextEditingController();
  final ScrollController _scrollController = ScrollController(keepScrollOffset: true);
  String errorMessage = "";
  Map<ChatMessage,AnimationController> messageAnimationControllers = {};

  @override
  initState() {
    _state = ChatViewState.loading;
    super.initState();
    _connect();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(authInfo: widget.args.authInfo, chat:  widget.args.chat),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if(_state == ChatViewState.loaded)
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: double.infinity),
              alignment: Alignment.bottomCenter,
              child: ListView(
                controller: _scrollController,
                shrinkWrap: true,
                children:[
                  for(final messageGroup in _messagesChannel.messagesGroups)
                    Padding(
                      padding: const EdgeInsets.only(right: 3, bottom: 6),
                      child: DefaultMessagesGroupView(
                        authInfo: widget.args.authInfo, 
                        messageAnimationControllers: messageAnimationControllers, 
                        messages: messageGroup.messages,
                      ),
                    )
                ]
              ),
            ),
          ),
          if(_state == ChatViewState.loading)
            const Center(child: LinearProgressIndicator()),
          if(_state == ChatViewState.errored)
            Expanded(child: Center(child: Text(errorMessage))),
          ChatTextField(
            controller: _inputContriller,
            onSend: _sendMessage,
          )
        ],
      ),
    );
  }
  Future _connect() async {
    final chatId = widget.args.chat.id;
    _messagesChannel.onDisconnect.addListener(_onDisconnect);
    _messagesChannel.onSended.addListener(_onSended);
    _messagesChannel.onReceived.addListener(_onReceived);
    _messagesChannel.onReceivedChanged.addListener(_onReceivedChanged);
    await _messagesChannel.connect(chatId);
    setState(() { _state = ChatViewState.loaded; });
  }
  void _onSended(ChatMessage eventData) {
    setState(() {});
  }
  void _onReceived(ChatMessage eventData) {
    setState(() {
      _animateMessageExpanding(eventData);
    });
  }
  void _onReceivedChanged(ChatMessage eventData) {
    setState(() {});
  }
  void _onDisconnect(DisconnectReson? reson){
    if(reson == null || reson.code == DisconnectReson.normal) return;
    errorMessage = "Ошибка:";
    switch(reson.code){
      case(DisconnectReson.authError):
        errorMessage += "вы не авторизованы.";
        break;
      case(DisconnectReson.argumentsError):
        errorMessage += "неизвестный чат.";
        break;
      default:
        errorMessage += "${reson.code}";
        if(Env.debug) errorMessage += reson.message;
        break;
    }
    setState(() { _state = ChatViewState.errored; });
  }
  _sendMessage(String text) async {
    setState((){
      ChatMessage message = _messagesChannel.send(text);
      _animateMessageExpanding(message);
    });
  }
  Future _animateMessageExpanding(ChatMessage message) async {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    jumpEnd()=>_scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    controller.addListener(jumpEnd);
    messageAnimationControllers[message] = controller;
    await controller.forward();
    controller.removeListener(jumpEnd);
    messageAnimationControllers.remove(message);
  }
  
  @override
  dispose(){
    _messagesChannel.disconnect();
    super.dispose();
  }
}