import 'dart:async';

import 'package:practice2/features/entities/habbit.dart';
import 'package:practice2/features/widgets/habbits_store.dart';

typedef HabbitIdGenerator = int Function();
typedef CurrentDateTimeProvider = DateTime Function();

class HabbitsStoreImpl implements HabbitsStore {
  List<Habbit> _habbits = [];
  final DateTime Function() currentDateTime;
  final int Function() nextHabbitId;
  final _controller = StreamController<List<Habbit>>.broadcast();

  HabbitsStoreImpl({required this.currentDateTime, required this.nextHabbitId});

  @override
  Stream<List<Habbit>> watchHabbits() async* {
    yield List.unmodifiable(_habbits);

    await for (final habbits in _controller.stream) {
      yield habbits;
    }
  }

  @override
  void addHabbit({
    required String name,
    required String iconUrl,
    required int targetDays,
  }) {
    var newHabbit = Habbit(
      id: nextHabbitId(),
      name: name,
      createdAt: currentDateTime(),
      iconUrl: iconUrl,
      targetDays: targetDays,
    );

    _emit([..._habbits, newHabbit]);
  }

  @override
  void ackHabbit({required int habbitId}) {
    _modify(habbitId: habbitId, mutation: (h) => h.withAck(currentDateTime()));
  }

  @override
  void breakHabbit({required int habbitId}) {
    _modify(
      habbitId: habbitId,
      mutation: (h) => h.withBreak(currentDateTime()),
    );
  }

  @override
  void removeHabbit({required int habbitId}) {
    _emit(_habbits.where((h) => h.id != habbitId).toList());
  }

  void _modify({
    required int habbitId,
    required Habbit Function(Habbit) mutation,
  }) {
    var index = _habbits.indexWhere((h) => h.id == habbitId);
    var next = List<Habbit>.from(_habbits);
    next[index] = mutation(_habbits[index]);
    _emit(next);
  }

  void _emit(List<Habbit> next) {
    _habbits = next;
    _controller.add(List.unmodifiable(_habbits));
  }

  @override
  List<Habbit> get habbits => List.unmodifiable(_habbits);

  @override
  void editHabbit({
    required int habbitId,
    required String name,
    required String iconUrl,
    required int targetDays,
  }) {
    _modify(
      habbitId: habbitId,
      mutation: (h) =>
          h.withName(name).withTargetDays(targetDays).withIconUrl(iconUrl),
    );
  }

  @override
  Habbit getHabbit({required int habbitId}) {
    return habbits.where((h) => h.id == habbitId).first;
  }
}
