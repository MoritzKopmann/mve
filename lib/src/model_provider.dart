import 'package:flutter/material.dart';
import 'package:mvu/src/model.dart';
import 'state_view.dart';

class ModelProvider<T extends Model<T>> extends StatelessWidget {
  final T model;
  final StateView<T> stateView;

  const ModelProvider({
    super.key,
    required this.model,
    required this.stateView,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: model.stream,
      initialData: model,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state == null) {
          return stateView.nullStateView(context, model.triggerEvent);
        }
        return stateView.view(context, state, model.triggerEvent);
      },
    );
  }
}
