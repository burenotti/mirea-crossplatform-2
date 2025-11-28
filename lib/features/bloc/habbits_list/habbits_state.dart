import 'dart:collection';

import 'package:practice2/features/entities/habbit.dart';

enum HabbitsLoadingState { loading, success, error }

final class HabbitsState {
  final List<Habbit> _habbits;
  final String? errorMessage;
  final HabbitsLoadingState loadingState;

  HabbitsState({
    required List<Habbit> habbits,
    required this.loadingState,
    this.errorMessage,
  }) : _habbits = habbits;

  List<Habbit> get habbits => _habbits;

  factory HabbitsState.initial() => HabbitsState(
    habbits: [],
    errorMessage: null,
    loadingState: HabbitsLoadingState.loading,
  );

  HabbitsState _copyWith({
    List<Habbit>? habbits,
    String? errorMessage,
    HabbitsLoadingState? loadingState,
  }) => HabbitsState(
    habbits: habbits ?? _habbits,
    errorMessage: errorMessage ?? this.errorMessage,
    loadingState: loadingState ?? this.loadingState,
  );

  HabbitsState loading() =>
      _copyWith(loadingState: HabbitsLoadingState.loading);

  HabbitsState success({required List<Habbit> habbits}) => _copyWith(
    loadingState: HabbitsLoadingState.success,
    errorMessage: null,
    habbits: habbits,
  );

  HabbitsState error(String errorMessage) => _copyWith(
    loadingState: HabbitsLoadingState.error,
    errorMessage: errorMessage,
  );
}
