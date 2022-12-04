import 'package:matcha/models/message_status.dart';

class ChatMessage{
  final String text;
  final DateTime dateTime;
  final int authorId;
  final MessgaeStatus status;
  const ChatMessage(this.text, this.dateTime, this.authorId, this.status);
}