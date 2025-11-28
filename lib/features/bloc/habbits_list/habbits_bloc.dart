import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:practice2/features/bloc/habbits_list/habbits_event.dart';
import 'package:practice2/features/bloc/habbits_list/habbits_state.dart';
import 'package:practice2/features/entities/habbit.dart';
import 'package:practice2/features/widgets/habbits_store.dart';

class HabbitsBloc extends Bloc<HabbitEvent, HabbitsState> {
  final HabbitsStore _store;

  HabbitsBloc({required HabbitsStore habbitsStore})
    : _store = habbitsStore,
      super(HabbitsState.initial()) {
    on<HabbitAcked>(_ackHabbit);
    on<HabbitBreaked>(_breakHabbit);
    on<SubscriptionRequested>(_onSubscriptionRequested);

    add(SubscriptionRequested());
  }

  FutureOr<void> _onSubscriptionRequested(
    SubscriptionRequested event,
    Emitter<HabbitsState> emit,
  ) async {
    emit(state.loading());

    await emit.forEach<List<Habbit>>(
      _store.watchHabbits(),
      onData: (habbits) => state.success(habbits: habbits),
      onError: (error, _) => state.error(error.toString()),
    );
  }

  void _ackHabbit(HabbitAcked event, Emitter<HabbitsState> emit) {
    emit(state.loading());
    _store.ackHabbit(habbitId: event.habbitId);
  }

  void _breakHabbit(HabbitBreaked event, Emitter<HabbitsState> emit) {
    emit(state.loading());
    _store.breakHabbit(habbitId: event.habbitId);
  }
}
