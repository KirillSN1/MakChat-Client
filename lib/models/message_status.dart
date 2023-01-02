import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum MessageStatus{
  sending(0),
  sended(1),
  readed(2);
  final int value;
  const MessageStatus(this.value);
  static MessageStatus byValue(int value,[MessageStatus? byDefault]){
    return MessageStatus.values.firstWhere((el) => 
      el.value == value, orElse: ()=>byDefault ?? MessageStatus.sended);
  }
}