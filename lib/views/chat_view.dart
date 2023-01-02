import 'package:flutter/material.dart';
import 'package:matcha/chat/ws_chat_client/disconnect_reson.dart';
import 'package:matcha/chat/ws_chat_client/ws_chat_client.dart';
import 'package:matcha/chat/ws_messages/client/ws_chat_request/ws_chat_request.dart';
import 'package:matcha/chat/ws_messages/server/ws_chat_message/ws_chat_message.dart';
import 'package:matcha/env.dart';
import 'package:matcha/models/chat_message/chat_message.dart';
import 'package:matcha/models/message_status.dart';
import 'package:matcha/models/messages_groups_list.dart';
import 'package:matcha/routes/args/chat_args.dart';
import 'package:matcha/views/components/chat/chat_text_field.dart';
import 'package:matcha/views/components/chat/messages_groups_view.dart';
import 'package:matcha/views/components/custom_back_button.dart';


enum ChatViewState{
  loading, loaded, errored
}


class ChatView extends StatefulWidget{
  final ChatArgs args;

  ChatView({super.key, required this.args }){
    if(args == null) throw ArgumentError(args,"args");
  }

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  // JsonSocket? _socket;
  final WSChatClient _client = WSChatClient();
  late ChatViewState _state;
  // final List<ChatMessage> _messages = [];
  final MessagesGrouper _messagesGrouper = MessagesGrouper();
  final _inputContriller = TextEditingController();
  final ScrollController _scrollController = ScrollController(keepScrollOffset: true);
  String errorMessage = "";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Hero(
                tag: "avatar_${(widget.args.authInfo.user.id).toString()}",
                child: const CircleAvatar(
                  radius: 23,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.bookmark_outline_rounded, color: Colors.white,),
                ),
              ),
            ),
            Text(widget.args.chat.name)
          ],
        )
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if(_state == ChatViewState.loaded)
          Expanded(
            child: ListView(
              controller: _scrollController,
              children:[
                for(final messageGroup in _messagesGrouper.groups.entries)
                  MessagesGroupView(
                    authInfo: widget.args.authInfo, 
                    messages: messageGroup.value,
                  )
              ]
            ),
          ),
          if(_state == ChatViewState.loading)
            const Center(child: LinearProgressIndicator()),
          if(_state == ChatViewState.errored)
            Expanded(child: Center(child: Text(errorMessage))),
          ChatTextField(
            controller: _inputContriller,
            onSend: (_)=>_sendInputData(),
          )
        ],
      ),
    );
  }

  @override
  initState() {
    _state = ChatViewState.loading;
    super.initState();
    _connect();
  }
  Future _connect() async {
    final chatId = widget.args.chat.id;
    _client.onConnect.addListener(_onConnect);
    _client.onMessage.addListener(_onGiveMessage);
    _client.onDisconnect.addListener(_onDisconnect);
    await _client.connect(chatId, widget.args.authInfo.token);
    setState(() { _state = ChatViewState.loaded; });
  }
  void _onConnect(_) {
    setState(() { _state = ChatViewState.loaded; });
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
  _onGiveMessage(WSChatMessage? message){
    if(message == null) return;
    setState(() {
      final messageDateTime = DateTime.fromMillisecondsSinceEpoch(message.updated_at);
      final groupKey = MessagesGroupKey.from(message.appUserId, messageDateTime);
      final messageGroup = _messagesGrouper.groups[groupKey];
      final chatMessageIndex = messageGroup==null?-1:messageGroup.indexWhere(
        (m)=>m.id == message.id ||
          m.id == 0 &&
          m.authorId == message.appUserId &&
          m.text == message.text &&
          m.dateTime.millisecondsSinceEpoch == message.created_at);
      if(messageGroup != null && chatMessageIndex >= 0){
        final chatMessage = messageGroup[chatMessageIndex];
        if(chatMessage.id == message.id){
          chatMessage.text = message.text;
          chatMessage.changed = message.changed;
          chatMessage.dateTime = DateTime.fromMillisecondsSinceEpoch(message.updated_at);
        }
        if(chatMessage.id == ChatMessage.defaultId) chatMessage.id = message.id;
        chatMessage.status = MessageStatus.byValue(message.status,MessageStatus.sended);
      }
      else{
        _messagesGrouper.add(ChatMessage(
          message.id,
          message.text,
          DateTime.fromMillisecondsSinceEpoch(message.updated_at),
          message.appUserId,
          MessageStatus.byValue(message.status,MessageStatus.sended),
          message.changed
        ));
      }
    });
  }
  @override
  dispose(){
    _client.disconnect();
    super.dispose();
  }
  void _sendInputData() {
    final text = _inputContriller.value.text;
    final message = ChatMessage.create(text, widget.args.authInfo.user.id);
    _client.send(
      WSChatRequest(
        text: text, 
        dateTime: message.dateTime.millisecondsSinceEpoch
      ),
      true
    );
    setState(() {
      _messagesGrouper.add(message);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.ease);
    });
  }
}