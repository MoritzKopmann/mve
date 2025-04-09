import 'dart:async';

import 'package:flutter/material.dart';

import 'event.dart';
import 'sink_and_stream.dart';
import 'state_view.dart';

/// Manages a model of type [T] and its updates through events, providing
/// a framework for building reactive user interfaces.
///
/// Integrates with [EventHandler] for event handling to update the model's state.
/// This controller facilitates the triggering of events and the construction of views
/// that reflect the current state of the model.
abstract class Model<T> {
  final _events = EventStream<T>();

  final _outEvents = BroadcastStream<OutEvent<T>>();

  Stream<OutEvent<T>> get outEventStream => _outEvents.stream;

  final BroadcastStream<T> _state = BroadcastStream<T>();

  _updateModel(Event<T> event) {
    event.updateModel(this as T, _triggerEvent, _triggerOutEvent);
  }

  Model() {
    _initEventStreamListener();
    _notifyListeners();
  }

  void _initEventStreamListener() {
    _events.stream.listen((Event<T> event) async {
      _updateModel(event);
      _notifyListeners();
    });
  }

  /// Triggers an [Event] to update the model.
  ///
  /// Adds the [Event] to a stream of events which are then handled to update the model.
  void _triggerEvent(Event<T> event) {
    _events.sink.add(event);
  }

  /// Triggers an [OutEvent] to notify partent Model about changes.
  void _triggerOutEvent(OutEvent<T> outEvent) {
    _outEvents.sink.add(outEvent);
  }

  _notifyListeners() {
    _state.sink.add(this as T);
  }

  Widget view(StateView<T> stateView, {Key? key}) {
    return StreamBuilder<T>(
      key: key,
      stream: _state.stream,
      initialData: this as T,
      builder: (context, snapshot) {
        T? state = snapshot.data;
        if (state == null) {
          return stateView.nullStateView(context, _triggerEvent);
        }
        return stateView.view(context, state, _triggerEvent);
      },
    );
  }
}
