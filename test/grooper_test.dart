import 'package:matcha/models/chat_message/chat_message.dart';
import 'package:matcha/models/message_status.dart';
import 'package:test/test.dart';
import 'package:matcha/models/messages_grouper.dart';

void main() {
  test('Group matches message correctly.',(){
    var grooper = MessagesGrouper();
    var m = createMessageWithTime(0,DateTime.parse("2023-04-16 22:07:00"));
    var m1 = createMessageWithTime(1,DateTime.parse("2023-04-16 22:07:00"));
    grooper.add(m);
    final matches = grooper.groups[0].matchByTime(m1);
    expect(matches, true);
  });
  test('Messages sorts by different groups.', () {
    final grooper = MessagesGrouper();
    final createdMessages = <ChatMessage>[];
    const groupsCount = 3;
    const messagesInGroupCount = 2;
    for(int messageIndex = 1; messageIndex<=messagesInGroupCount; messageIndex++){
      for(int groupIndex = 1; groupIndex<=groupsCount; groupIndex++){
        print("created message ${groupIndex*messageIndex}");
        var m = createMessageWithTime(groupIndex*messageIndex,DateTime.parse("2023-04-16 22:0$groupIndex:0$messageIndex"));
        createdMessages.add(m);
        grooper.add(m);
      }
    }
    expect(createdMessages.length, groupsCount*messagesInGroupCount, reason: "Ошибка в тесте. Ожидалось другое количество сообщений.");
    expect(grooper.groups.length, groupsCount, reason: "Ожидалось другое количество групп.");
    for(int i = createdMessages.length-1; i<=0; i--) {
      expect(grooper.groups[0].messages[0].id, i, reason: "Порядок сообщений в группах нарушен.");
    }
  });
  test("Messages adds into the end of list",(){
    final grooper = MessagesGrouper();
    ChatMessage controlMessage;
    grooper.add(createMessageWithUser(1, 1, DateTime.parse("2023-04-16 21:00:00")));
    grooper.add(createMessageWithUser(2, 2, DateTime.parse("2023-04-16 21:00:01")));
    grooper.add(controlMessage = createMessageWithUser(3, 1, DateTime.parse("2023-04-16 21:00:02")));
    expect(grooper.messages.last.id,controlMessage.id,reason: "Последнее сообщение добавилось не в последнюю/новую группу.");
  });
  test("Gropper initialises correctly with prepared messages list.",(){
    final messages = <ChatMessage,MessagePosition>{//message:{ groupIndex:messagesIndex } предполагаемое положение сообщения в списке групп
      ChatMessage(0, "0", DateTime.parse("2023-04-16 21:00:00"), 0, MessageStatus.sended, false):const MessagePosition(0,0),
      ChatMessage(0, "0", DateTime.parse("2023-04-16 22:00:00"), 0, MessageStatus.sended, false):const MessagePosition(2,0),
      ChatMessage(0, "0", DateTime.parse("2023-04-16 22:01:00"), 0, MessageStatus.sended, false):const MessagePosition(3,0),
      ChatMessage(0, "0", DateTime.parse("2023-04-16 21:00:01"), 0, MessageStatus.sended, false):const MessagePosition(0,1),
      ChatMessage(0, "0", DateTime.parse("2023-04-16 21:01:00"), 0, MessageStatus.sended, false):const MessagePosition(1,0),
    };
    final grooper = MessagesGrouper(messages.keys.toList());
    // expect(grooper.messages.last.id,controlMessage.id,reason: "Последнее сообщение добавилось не в последнюю/новую группу.");
    for(int i = 0; i<messages.length; i++) {
      final message = messages.keys.elementAt(i);
      final position = messages.values.elementAt(i);
      final groupIndex = grooper.groups.indexWhere((element) => element.messages.contains(message));
      expect(groupIndex, position.group, reason: "Индекс группы, в которую было помещено сообщение со временем ${message.dateTime} не соответствует ожидаемому.");
      final messageIndex = grooper.groups[groupIndex].messages.indexOf(message);
      expect(messageIndex, position.index, reason: "Индекс сообщения, в группе не соответствует ожидаемому.");
    }
  });
}
class MessagePosition{
  final int group, index;
  const MessagePosition(this.group,this.index); 
}
createMessageWithTime(int id,DateTime time){
  return ChatMessage(0, "", time, 1, MessageStatus.sending, false);
}
createMessageWithUser(int id, int userId,DateTime time){
  return ChatMessage(id, "", time, userId, MessageStatus.sending, false);
}
