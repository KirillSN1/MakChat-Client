import 'package:matcha/low/event.dart';

class NamedEventsController<D>{
  late final NamedEventsProvider<D> provider;
  NamedEventsController(Iterable<String> types): provider = NamedEventsProvider<D>(types);
  invoke(String name, D data){
    if(!provider._events.containsKey(name)) return;
    final listenersOptionsList = [...provider._events[name]!];
    for(final listenerOptions in listenersOptionsList){
      if(listenerOptions.once) provider._events[name]!.remove(listenerOptions);
      listenerOptions.listener.call(data);
    }
  }
}

class NamedEventsProvider<D> {
  final _events = <String, List<_EventListenerOptions<D>>>{};
  NamedEventsProvider(Iterable<String> types){
    _events.addEntries(types.map((type) => MapEntry(type, [])));
  }
  void addListener(String type,EventListener<D> listener, {bool once = false}) {
    if(!_events.containsKey(type)) return;
    _events[type]!.add(_EventListenerOptions(listener));
  }
  void removeListener(String type,[EventListener<D>? listener]) {
    if(!_events.containsKey(type)) return;
    final optionsList = _events[type]!;
    if(listener == null) return optionsList.clear();
    final optionsIndex = optionsList.indexWhere((o) => o.listener == listener);
    if(optionsIndex<0) return;
    optionsList.removeAt(optionsIndex);
  }
  void removeAllListeners(){
    _events.forEach((key, value)=>value.clear());
  }
  void dispose(){
    removeAllListeners();
    _events.clear();
  }
}

class _EventListenerOptions<D>{
  final EventListener<D> listener;
  final bool once;
  _EventListenerOptions(this.listener,{ this.once = false });
}