typedef EventListener<D> = void Function(D eventData);
class Event<T>{
  Event();
  final List<EventListener<T?>> _listeners = [];
  void addListener(EventListener<T?> listener){
    _listeners.add(listener);
  }
  void removeListener(EventListener<T?> listener){
    _listeners.remove(listener);
  }
  void invoke([T? eventData]){
    for (final listener in _listeners) {
      listener.call(eventData);
    }
  }
}