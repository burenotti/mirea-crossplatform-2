sealed class HabbitEvent {
  const HabbitEvent();
}

final class SubscriptionRequested extends HabbitEvent {}

final class NewHabbitAdded extends HabbitEvent {
  final String name;
  final String iconUrl;
  final int targetDays;

  const NewHabbitAdded({
    required this.name,
    required this.iconUrl,
    required this.targetDays,
  });
}

final class HabbitInfoEdited extends HabbitEvent {
  final int habbitId;
  final String name;
  final String iconUrl;
  final int targetDays;

  const HabbitInfoEdited({
    required this.habbitId,
    required this.name,
    required this.iconUrl,
    required this.targetDays,
  });
}

final class HabbitAcked extends HabbitEvent {
  final int habbitId;

  const HabbitAcked({required this.habbitId});
}

final class HabbitBreaked extends HabbitEvent {
  final int habbitId;

  const HabbitBreaked({required this.habbitId});
}
