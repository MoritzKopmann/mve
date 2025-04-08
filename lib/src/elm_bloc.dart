import 'dart:async';

import 'package:elm_bloc/src/events.dart';
import 'package:elm_bloc/src/sink_and_stream.dart';
import 'package:elm_bloc/src/state_view.dart';
import 'package:flutter/material.dart';

/// Manages a model of type [T] and its updates through events, providing
/// a framework for building reactive user interfaces.
///
/// Integrates with [EventHandler] for event handling to update the model's state.
/// This controller facilitates the triggering of events and the construction of views
/// that reflect the current state of the model.
abstract class ElmBloc<T> {
  final _events = EventStream<T>();

  final _outEvents = BroadcastStream<OutEvent<T>>();

  Stream<OutEvent<T>> get outEventStream => _outEvents.stream;

  final BroadcastStream<T> _state = BroadcastStream<T>();

  FutureOr<OutEvent<T>?> _updateModel(Event<T> event) {
    return event.updateModel(this as T);
  }

  ElmBloc() {
    _initEventStreamListener();
    notifyListeners();
  }

  void _initEventStreamListener() {
    _events.stream.listen(
      (Event<T> event) async {
        OutEvent<T>? outEvent = await _updateModel(event);
        notifyListeners();

        if (outEvent != null) _outEvents.sink.add(outEvent);
      },
    );
  }

  /// Triggers an [Event] to update the model.
  ///
  /// Adds the [Event] to a stream of events which are then handled to update the model.
  void triggerEvent(Event<T> event) {
    _events.sink.add(event);
  }

  notifyListeners() {
    _state.sink.add(this as T);
  }

  Widget view(StateView<T> stateView, {Key? key}) {
    return StreamBuilder<T>(
      key: key,
      stream: _state.stream,
      initialData: this as T,
      builder: (context, snapshot) => stateView.view(
        context,
        snapshot.data,
        triggerEvent,
      ),
    );
  }
}
