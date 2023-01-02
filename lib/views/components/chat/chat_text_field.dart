import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ChatTextField extends StatefulWidget {
  final bool autofocus;
  final bool autoRequestFocus;
  final bool clearAfterSend;
  final bool enabled;
  final TextEditingController _controller;
  final FocusNode _focusNode;
  
  final void Function(String)? onSend;
  
  
  ChatTextField({
    super.key,
    this.autofocus = true,
    this.autoRequestFocus = true,
    this.clearAfterSend = true,
    this.enabled = true,
    TextEditingController? controller,
    FocusNode? focusNode,
    this.onSend
  }):
    _controller=controller ?? TextEditingController(),
    _focusNode=focusNode ?? FocusNode();

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  bool _canSend = false;
  
  @override
  void initState() {
    //TODO:message draft
    _canSend = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: Theme.of(context).bottomAppBarColor,
      child: Row(
        children: [
          Flexible(
            child: TextField(
              enabled: widget.enabled,
              controller: widget._controller,
              focusNode: widget._focusNode,
              autofocus: widget.autofocus,
              onChanged: _onChanged,
              onSubmitted: _onSend,
              textInputAction: Platform.isAndroid?TextInputAction.newline:TextInputAction.send,
              maxLines: 5,
              minLines: 1,
              decoration: const InputDecoration(
                hintText: "Сообщение",
                border: InputBorder.none
              ),
            ),
          ),
          IconButton(
            splashRadius: 15,
            enableFeedback: false,
            onPressed: widget.enabled?_onSend:null,
            // icon: const Icon(Icons.send_rounded)
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (child, anim) => RotationTransition(
                turns: child.key == const ValueKey('send_icon')
                  ? Tween<double>(begin: 1, end: 0.75).animate(anim)
                  : Tween<double>(begin: 0.75, end: 1).animate(anim),
                child: ScaleTransition(scale: anim, child: child),
              ),
              child: _canSend
                ? const RotatedBox(
                    key: ValueKey('send_icon'),
                    quarterTurns: 1,
                    child: Icon(Icons.send_rounded)
                  )
                : const Icon(Icons.attachment_sharp, key: ValueKey('attach_icon'))
            )
          )
        ],
      ),
    );
  }

  void _onSend([String? value]){
    final text = value ?? widget._controller.text;
    if(text.trim().isEmpty) return;
    widget.onSend?.call(text);
    if(widget.clearAfterSend) widget._controller.text = "";
    if(widget.autoRequestFocus) widget._focusNode.requestFocus();
  }

  void _onChanged(String value) {
    setState(() { _canSend = value.trim().isNotEmpty; });
  }
}