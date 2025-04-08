import 'dart:async';

import 'package:elm_bloc/src/events.dart';

class EventStream<T> {
  final _streamController = StreamController<Event<T>>();
  StreamSink<Event<T>> get sink => _streamController.sink;
  Stream<Event<T>> get stream => _streamController.stream;
}

class BroadcastStream<T> {
  final _streamController = StreamController<T>.broadcast();
  StreamSink<T> get sink => _streamController.sink;
  Stream<T> get stream => _streamController.stream;
}
