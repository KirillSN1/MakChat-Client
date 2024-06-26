typedef EventListener<D> = void Function(D eventData);
class Event<T>{
  final List<EventListener<T>> _listeners = [];
  void addListener(EventListener<T> listener, { bool once = false }){
    if(once){
      var original = listener;
      listener = (T t){
        removeListener(listener);
        original.call(t);
      };
    }
    _listeners.add(listener);
  }
  void removeListener(EventListener<T> listener){
    _listeners.remove(listener);
  }
  bool isListener(EventListener<T> listener){
    return _listeners.contains(listener);
  }
  invoke(T eventData){
    final listeners = [..._listeners];
    for (final listener in listeners) {
      listener.call(eventData);
    }
  }
}
class NullableEvent<T> extends Event<T?>{
  NullableEvent();
  @override
  void invoke([T? eventData]){
    final listeners = [..._listeners];
    for (final listener in listeners) {
      listener.call(eventData);
    }
  }
}