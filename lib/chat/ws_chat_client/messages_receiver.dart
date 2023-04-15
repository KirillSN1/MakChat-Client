import 'package:matcha/chat/ws_messages/ws_message_types.dart';
import 'package:matcha/low/event.dart';
import 'package:matcha/low/named_events.dart';
import 'package:matcha/structs/json.dart';

class MessageReceiver{
  final Event<Json?> _dataEvent;
  final _controller = NamedEventsController<Json>(PunchType.values.map((e) => e.name));
  MessageReceiver(Event<Json?> dataEvent):_dataEvent = dataEvent{
    _dataEvent.addListener(_onData);
  }
  _onData(Json? eventData){
    if(eventData == null) return;
    _controller.invoke(eventData['type'], eventData);
  }
  void addListener(String type, EventListener<Json> listener, { once = false }) => 
    _controller.provider.addListener(type, listener, once: once);
  void removeListener(String type, EventListener<Json> listener) => 
    _controller.provider.removeListener(type, listener);
  void removeAllListeners()=>_controller.provider.removeAllListeners();
  dispose(){
    _dataEvent.removeListener(_onData);
    _controller.provider.removeAllListeners();
  }
}