import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:matcha/models/chat/chat.dart';
import 'package:matcha/models/chat_message/chat_message.dart';
import 'package:matcha/models/chat_message/chat_message_data.dart';
import 'package:matcha/models/messages_channel.dart';
import 'package:matcha/models/messages_grouper.dart';
import 'package:matcha/routes/args/chat_args.dart';
import 'package:matcha/services/locator.dart';
import 'package:matcha/services/repositories/chat_repository.dart';
import 'package:matcha/services/repositories/messages_repository.dart';
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
  late final MessagesChannel _messagesChannel;
  late ChatViewState _state;
  final _inputContriller = TextEditingController();
  final ScrollController _scrollController = ScrollController(keepScrollOffset: true);
  String errorMessage = "";
  Map<ChatMessage,AnimationController> messageAnimationControllers = {};
  Chat? chat;
  final MessagesGrouper _messagesGrouper = MessagesGrouper();

  @override
  initState() {
    _state = ChatViewState.loading;
    super.initState();
    _init();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(chat: chat),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: double.infinity),
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(//TODO:ленивая загрузка сообщений
                controller: _scrollController,
                child:Column(
                  children:[
                    for(final messageGroup in _messagesGrouper.groups)
                      Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3, bottom: 6),
                        child: DefaultMessagesGroupView(
                          userId: widget.args.authInfo.user.id, 
                          messageAnimationControllers: messageAnimationControllers, 
                          messages: messageGroup.messages,
                        ),
                      )
                  ]
                )
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
  Future _init() async {
    log("chat_view init");
    chat = await _createSingleChat() ?? widget.args.chat;
    if(chat == null || chat!.id == 0) errorMessage = "Ошибка создания чата.";
    _messagesGrouper.addAll(await _loadHistory(chat!.id));
    _messagesChannel = Locator.messagesChannel;
    _messagesChannel.onAuthError.addListener(_onAuthError);
    _messagesChannel.onReceived.addListener(_onReceived);
    _messagesChannel.listen();
    setState(() {
      _state = ChatViewState.loaded;
      jumpEndOnPostFrame();
    });
  }
  Future<Iterable<ChatMessage>> _loadHistory(int chatId) async {
    final authInfo = widget.args.authInfo;
    final messagesData = await MessagesRepository.getMessagesHystory(authInfo, chatId);
    return messagesData.map((data) => ChatMessage(_messagesGrouper.messagesCount, data));
  }
  Future<Chat?> _createSingleChat() async {
    final args = widget.args;
    if(args is! NewSingleChatArgs) return null;
    return ChatRepository.create(args.authInfo, args.chat.users);
  }
  void _onReceived(ChatMessageData messageData) {
    if(messageData.chatId != widget.args.chat.id) return;
    final messages = _messagesGrouper.messages;
    final chatMessageIndex = messages.indexWhere((m)=>m.id==messageData.id);
    setState(() {
      if(chatMessageIndex>=0) {//если мне прилетело уже существующее сообщение
        messages[chatMessageIndex].data = messageData;
      } else {
        final message = ChatMessage(_messagesGrouper.messagesCount, messageData);
        _messagesGrouper.add(message);
        _animateMessageExpanding(message);
      }
    });
  }
  void _onAuthError(_){
    errorMessage = "Ошибка авторизации.";
    setState(() { _state = ChatViewState.errored; });
  }
  _sendMessage(String text) async {
    if(chat == null) throw Exception("chat must not be null");
    final sendingState = _messagesChannel.send(chat!.id, text);
    final message = ChatMessage(_messagesGrouper.messagesCount, sendingState.sendedData);
    _messagesGrouper.add(message);
    setState((){
      _animateMessageExpanding(message);
    });
    sendingState.sendingResult.then((value) => setState((){
      message.data = value;
    }));
  }
  Future _animateMessageExpanding(ChatMessage message) async {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    controller.addListener(jumpEndOnPostFrame);
    messageAnimationControllers[message] = controller;
    await controller.forward();
    controller.removeListener(jumpEndOnPostFrame);
    messageAnimationControllers.remove(message);
  }
  jumpEndOnPostFrame()=>WidgetsBinding.instance.addPostFrameCallback((_){
    jumpEnd();
  });
  ///Проклучивает [ListView] до максимального значения [ScrollPosition.maxScrollExtent]
  jumpEnd(){
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
  @override
  dispose(){
    _messagesChannel.stopListening();
    _messagesChannel.onDisconnect.removeListener(_onAuthError);
    _messagesChannel.onReceived.removeListener(_onReceived);
    messageAnimationControllers.forEach((key, value) =>value.stop());
    super.dispose();
  }
}