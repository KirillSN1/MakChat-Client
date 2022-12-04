import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:matcha/models/chat_message.dart';
import 'package:matcha/models/message_status.dart';
import 'package:matcha/routes/args/chat_args.dart';
import 'package:matcha/services/auth/auth.dart';
import 'package:matcha/services/connector.dart';
import 'package:matcha/services/json_socket.dart';
import 'package:matcha/views/components/chat/chat_message_view.dart';
import 'package:matcha/views/components/custom_back_button.dart';


enum ChatViewState{
  loading, loaded, errored
}


class ChatView extends StatefulWidget{
  final ChatArgs? args;

  const ChatView({super.key, this.args });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  JsonSocket? _soket;
  
  late ChatViewState _state;
  
  final List<ChatMessage> _messages = [];
  
  final _inputContriller = TextEditingController();

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
                tag: "avatar_${widget.args==null?"0":widget.args!.chat.id.toString()}",
                child: const CircleAvatar(
                  radius: 23,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.bookmark_outline_rounded, color: Colors.white,),
                ),
              ),
            ),
            widget.args==null?const Text("Unknown")
            :Text(widget.args!.chat.name)
          ],
        )
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                for(final message in _messages) 
                ChatMessageView(message: message)
              ],
            ),
          ),
          Row(
            children: [
              Expanded(child: TextField(controller: _inputContriller, autofocus: true, onSubmitted: (value)=>_sendInputData())),
              IconButton(onPressed: _sendInputData, icon: const Icon(Icons.send_rounded))
            ],
          )
        ],
      ),
    );
  }

  @override
  initState(){
    _state = ChatViewState.loading;
    super.initState();
    connect((Map<String,dynamic>? data){
      if(data?["message"]!=null) {
        setState(() {
          _messages.add(ChatMessage(data?["message"],DateTime.now(),1,MessgaeStatus.readed));
        });
      }
    }).then((value){
      setState(() {
        _state = ChatViewState.loaded;
        _soket = value;
      });
    });
  }

  @override
  dispose(){
    disconnect(true);
    super.dispose();
  }

  Future<JsonSocket> connect(void Function(Map<String, dynamic>?) listener) async {
    if(_soket != null) throw Exception("already connected");
    final socket = await JsonSocket.connect();
    socket.onData.addListener(listener);
    socket.listen();
    socket.send({ "type":"Auth", "token":await Auth.token });
    return socket;
  }
  disconnect([bool onDispose = true]){
    if(_soket == null) throw Exception("_soket was null");
    _soket!.close();
    if(!onDispose) {
      setState(() {
        _soket = null;
      });
    } else {
      _soket = null;
    }
  }

  void _sendInputData() {
    if(_soket == null) {
      setState(() {
        _state = ChatViewState.errored;
      });
      throw Exception("Connection Error (onsend)!");
    }
    final text = _inputContriller.value.text;
    _soket!.send({ "text":text });
    setState(() {
      _messages.add(ChatMessage(text, DateTime.now(), 0, MessgaeStatus.sended));
    });
  }
  _showSnackMessage(context,String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}