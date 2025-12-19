import 'package:practice2/features/entities/app_action.dart';

abstract class ActionsStore {
  Stream<AppAction> watchActions();
  void dispatch(AppAction action);
}
