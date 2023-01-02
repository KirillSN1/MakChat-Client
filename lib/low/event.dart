typedef EventListener<D> = void Function(D eventData);
class Event<T>{
  Event();
  final List<EventListener<T?>> _listeners = [];
  void addListener(EventListener<T?> listener, { bool once = false }){
    if(once){
      var original = listener;
      listener = (T? t){
        removeListener(original);
        original.call(t);
      };
    }
    _listeners.add(listener);
  }
  void removeListener(EventListener<T?> listener){
    _listeners.remove(listener);
  }
  void invoke([T? eventData]){
    final listeners = [..._listeners];
    for (final listener in listeners) {
      listener.call(eventData);
    }
  }
}