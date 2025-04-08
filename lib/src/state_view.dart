import 'package:elm_bloc/src/events.dart';
import 'package:flutter/material.dart';

/// Defines an interface for building state-based widgets.
///
/// Implementations must provide the [view] function to render UI components
/// corresponding to the state of type [T].
abstract class StateView<T> {
  /// Builds and returns a widget in response to the state [currentState].
  ///
  /// The [triggerEventFunction] can be used within the UI to trigger state changes.
  ///
  /// - [context]: The location in the widget tree where the UI is built.
  /// - [currentState]: The current state data which may be null if not set.
  /// - [triggerEventFunction]: A function that triggers an event of [Event<T>].
  Widget view(BuildContext context, T? currentState,
      Function(Event<T> event) triggerEventFunction);
}
