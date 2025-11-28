import 'package:bloc/bloc.dart';
import 'package:practice2/features/entities/habbit.dart';
import 'package:practice2/features/widgets/habbits_store.dart';

class HabitEditorState {
  final String name;
  final String iconUrl;
  final int targetDays;
  final bool submitting;
  final String? error;

  const HabitEditorState({
    this.name = '',
    this.iconUrl = '',
    this.targetDays = 1,
    this.submitting = false,
    this.error,
  });

  HabitEditorState copyWith({
    String? name,
    String? iconUrl,
    int? targetDays,
    bool? submitting,
    String? error,
  }) => HabitEditorState(
    name: name ?? this.name,
    iconUrl: iconUrl ?? this.iconUrl,
    targetDays: targetDays ?? this.targetDays,
    submitting: submitting ?? this.submitting,
    error: error,
  );
}

class HabbitEditorCubit extends Cubit<HabitEditorState> {
  final HabbitsStore store;
  final int? habitId; // null => создание

  HabbitEditorCubit(this.store, {this.habitId, Habbit? initial})
    : super(
        HabitEditorState(
          name: initial?.name ?? '',
          iconUrl: initial?.iconUrl ?? '',
          targetDays: initial?.targetDays ?? 1,
        ),
      );

  void nameChanged(String v) => emit(state.copyWith(name: v));
  void iconChanged(String v) => emit(state.copyWith(iconUrl: v));
  void targetChanged(int v) => emit(state.copyWith(targetDays: v));

  Future<void> submit() async {
    emit(state.copyWith(submitting: true, error: null));
    try {
      if (habitId == null) {
        store.addHabbit(
          name: state.name,
          iconUrl: state.iconUrl,
          targetDays: state.targetDays,
        );
      } else {
        store.editHabbit(
          habbitId: habitId!,
          name: state.name,
          iconUrl: state.iconUrl,
          targetDays: state.targetDays,
        );
      }
      emit(state.copyWith(submitting: false));
    } catch (e) {
      emit(state.copyWith(submitting: false, error: e.toString()));
    }
  }
}
