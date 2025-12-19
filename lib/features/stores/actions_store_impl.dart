import 'dart:async';
import 'package:practice2/features/entities/app_action.dart';
import 'package:practice2/features/stores/actions_store.dart';

class ActionsStoreImpl implements ActionsStore {
  final _controller = StreamController<AppAction>.broadcast();

  @override
  Stream<AppAction> watchActions() {
    return _controller.stream;
  }

  @override
  void dispatch(AppAction action) {
    _controller.add(action);
  }

  void dispose() {
    _controller.close();
  }
}
