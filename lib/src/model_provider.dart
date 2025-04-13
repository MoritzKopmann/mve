import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvu/src/event.dart';
import 'package:mvu/src/sink_and_stream.dart';
import 'package:mvu/src/state_view.dart';

/// Manages a model of type [T] and its updates through events, providing
/// a framework for building reactive user interfaces.
///
/// Integrates with [EventHandler] for event handling to update the model's state.
/// This controller facilitates the triggering of events and the construction of views
/// that reflect the current state of the model.
abstract class ModelProvider<T> extends StatefulWidget {
  final T _state;

  final StateView<T> _stateView;

  final _events = EventStream<T>();

  final _outEvents = OutEventStream<T>();

  Stream<OutEvent<T>> get outEventStream => _outEvents.stream;

  final BroadcastStream<T> _stateStream = BroadcastStream<T>();

  _updateModel(Event<T> event) {
    event.updateModel(_state, _triggerEvent, _triggerOutEvent);
  }

  ModelProvider({super.key, required T state, required StateView<T> stateView})
      : _stateView = stateView,
        _state = state {
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
    assert(() {
      debugPrint("Triggering event: ${event.runtimeType}");
      return true;
    }());
    _events.sink.add(event);
  }

  /// Triggers an [OutEvent] to notify partent Model about changes.
  void _triggerOutEvent(OutEvent<T> outEvent) {
    assert(() {
      debugPrint("Triggering out-event: ${outEvent.runtimeType}");
      return true;
    }());
    _outEvents.sink.add(outEvent);
  }

  _notifyListeners() {
    _stateStream.sink.add(_state);
  }

  void dispose() {
    _stateStream.dispose();
    _events.dispose();
    _outEvents.dispose();
  }

  Widget _view({Key? key}) {
    return StreamBuilder<T>(
      key: key,
      stream: _stateStream.stream,
      initialData: _state,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _stateView.nullStateView(context, _triggerEvent);
        }
        return _stateView.view(context, snapshot.requireData, _triggerEvent);
      },
    );
  }

  @override
  // ignore: no_logic_in_create_state
  State<ModelProvider<T>> createState() => _ModelProviderState<T>(_view);
}

class _ModelProviderState<T> extends State<ModelProvider<T>> {
  Function({Key? key}) view;

  _ModelProviderState(this.view);

  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return view();
  }
}
