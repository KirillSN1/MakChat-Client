import 'package:matcha/chat/ws_chat_client/ws_chat_client.dart';
import 'package:matcha/models/user/user.dart';
import 'package:matcha/services/repositories/auth/auth_info.dart';
import '../../models/chat/chat.dart';

abstract class ChatArgs{
  final AuthInfo authInfo;
  final Chat chat;
  const ChatArgs({ required this.authInfo, required this.chat});
}
class SingleChatArgs extends ChatArgs {
  SingleChatArgs({ required super.authInfo, required super.chat});
}
class NewSingleChatArgs extends ChatArgs{
  final User user;
  NewSingleChatArgs({ required super.authInfo, required this.user })
    :super(chat: Chat(id: 0, name: user.login));
}