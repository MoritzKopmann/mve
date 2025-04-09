/// Represents an event that updates a model of type [T].
///
/// Implementers must define [updateModel] to specify how the model is updated.
abstract class Event<T> {
  /// Updates [model] based on the event.
  ///
  /// must be synchronous
  void updateModel(
    T model,
    Function(Event<T> event) triggerEvent,
    Function(OutEvent<T> triggerOutEvent) triggerOutEvent,
  );
}

class UpdateView<T> implements Event<T> {
  @override
  void updateModel(_, ___, ____) => {};
}

abstract class OutEvent<T> {}
