import 'package:matcha/services/repositories/auth/auth_info.dart';

import '../../models/chat.dart';
import '../../models/user/user.dart';

class ChatArgs{
  final AuthInfo authInfo;
  final Chat chat;
  const ChatArgs({ required this.authInfo, required this.chat});
}