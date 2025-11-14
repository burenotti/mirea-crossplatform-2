import 'package:practice2/features/entities/habbit.dart';
import 'package:practice2/features/widgets/habbits_controller.dart';

class HabbitsContainer implements HabbitsController {
  List<Habbit> _habbits = [];
  final DateTime Function() currentDateTime;
  final int Function() nextHabbitId;

  HabbitsContainer({required this.currentDateTime, required this.nextHabbitId});

  @override
  void addHabbit({
    required String name,
    required String iconUrl,
    required int targetDays,
  }) {
    _habbits.add(
      Habbit(
        id: nextHabbitId(),
        name: name,
        createdAt: currentDateTime(),
        iconUrl: iconUrl,
        targetDays: targetDays,
      ),
    );
  }

  @override
  void ackHabbit({required int habbitId}) {
    _exchange(
      habbitId: habbitId,
      mutation: (h) => h.withAck(currentDateTime()),
    );
  }

  @override
  void breakHabbit({required int habbitId}) {
    _exchange(
      habbitId: habbitId,
      mutation: (h) => h.withBreak(currentDateTime()),
    );
  }

  @override
  void removeHabbit({required int habbitId}) {
    _habbits = _habbits.where((h) => h.id != habbitId).toList();
  }

  void _exchange({
    required int habbitId,
    required Habbit Function(Habbit) mutation,
  }) {
    var index = _habbits.indexWhere((h) => h.id == habbitId);
    _habbits[index] = mutation(_habbits[index]);
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
    _exchange(
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
