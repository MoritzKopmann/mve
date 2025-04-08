import 'dart:async';

/// Represents an event that updates a model of type [T].
///
/// Implementers must define [updateModel] to specify how the model is updated.
abstract class Event<T> {
  /// Updates [model] based on the event.
  ///
  /// Can be synchronous or asynchronous, hence returns [FutureOr<void>].
  FutureOr<OutEvent<T>?> updateModel(T model);
}

class UpdateView<T> implements Event<T> {
  @override
  FutureOr<OutEvent<T>?> updateModel(_) => null;
}

abstract class OutEvent<T> {}
