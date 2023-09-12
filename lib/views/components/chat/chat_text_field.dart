import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';

class ChatTextField extends StatefulWidget {
  final bool autofocus;
  final bool autoRequestFocus;
  final bool clearAfterSend;
  final bool enabled;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  
  final void Function(String)? onSend;
  
  
  const ChatTextField({
    super.key,
    this.autofocus = true,
    this.autoRequestFocus = true,
    this.clearAfterSend = true,
    this.enabled = true,
    this.controller,
    this.focusNode,
    this.onSend
  });

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  bool _canSend = false;
  late final TextEditingController _controller = widget.controller ?? TextEditingController();
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
  
  @override
  void initState() {
    //TODO:message draft
    RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.shift);
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
              controller: _controller,
              focusNode: _focusNode,
              // autofocus: widget.autofocus,
              onChanged: _onChanged,
              onSubmitted: _onSend,
              onEditingComplete: (){},
              textInputAction: Platform.isAndroid?TextInputAction.newline:TextInputAction.send,
              maxLines: 5,
              minLines: 1,
              decoration: const InputDecoration(
                hintText: "Сообщение",
                border: InputBorder.none,
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
    const shiftSet = [
      LogicalKeyboardKey.shift,
      LogicalKeyboardKey.shiftLeft,
      LogicalKeyboardKey.shiftRight
    ];
    final shift = RawKeyboard.instance.keysPressed.any((key) => shiftSet.contains(key));
    if(shift) return;
    final text = value ?? _controller.text;
    if(text.trim().isNotEmpty){
      widget.onSend?.call(text.replaceAll(RegExp(r'(^\n)|(\n$)'),""));
    }
    if(widget.clearAfterSend) {
      _controller.clear();
      _onChanged("");
    }
  }

  void _onChanged(String value) {
    setState(() { _canSend = value.trim().isNotEmpty; });
  }
}