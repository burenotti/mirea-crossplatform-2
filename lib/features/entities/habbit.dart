/// Тип иконки для привычки
enum HabbitIcon { smoking, running, reading, water, sport }

class HabbitAction {
  final DateTime occuredOn;

  const HabbitAction({required this.occuredOn});
}

class Ack extends HabbitAction {
  Ack({required super.occuredOn});
}

class Break extends HabbitAction {
  Break({required super.occuredOn});
}

class Habbit {
  final int id;
  final String name;
  final HabbitIcon icon;
  final DateTime createdAt;
  final int targetDays;
  final List<HabbitAction> _events;

  factory Habbit({
    required int id,
    required String name,
    required HabbitIcon icon,
    required DateTime createdAt,
    required int targetDays,
  }) {
    return Habbit._(
      id: id,
      name: name,
      icon: icon,
      createdAt: createdAt,
      targetDays: targetDays,
      events: const [],
    );
  }

  const Habbit._({
    required this.id,
    required this.name,
    required this.icon,
    required this.createdAt,
    required this.targetDays,
    required List<HabbitAction> events,
  }) : _events = events;

  Habbit withName(String newName) {
    return _copyWith(name: newName);
  }

  Habbit withTargetDays(int targetDays) {
    return _copyWith(targetDays: targetDays);
  }

  Habbit withIcon(HabbitIcon icon) {
    return _copyWith(icon: icon);
  }

  Habbit _copyWith({
    String? name,
    HabbitIcon? icon,
    DateTime? createdAt,
    int? targetDays,
    List<HabbitAction>? events,
  }) {
    return Habbit._(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      targetDays: targetDays ?? this.targetDays,
      events: events ?? _events,
    );
  }

  Habbit withAck(DateTime now) {
    if (isGoalReached) throw Exception("Can't ack habbit with reached goal");
    return _copyWith(
      events: List.unmodifiable([..._events, Ack(occuredOn: now)]),
    );
  }

  Habbit withBreak(DateTime now) {
    if (isGoalReached) {
      throw Exception("Can't add break to habbit with reached goal");
    }
    return _copyWith(
      events: List.unmodifiable([..._events, Break(occuredOn: now)]),
    );
  }

  Iterable<Ack> get _acks => _events.whereType<Ack>();
  Iterable<Break> get _breaks => _events.whereType<Break>();

  List<HabbitAction> get events => List.unmodifiable(_events);

  int get currentProgress => currentAcks - currentBreaks;
  bool get isGoalReached => currentProgress >= targetDays;

  int get currentAcks => _acks.length;
  int get currentBreaks => _breaks.length;
}
