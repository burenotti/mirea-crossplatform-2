class HabbitModel {
  final int id;
  final String name;
  final DateTime createdAt;
  final int maxStreakLength;
  final int currentStreakLength;
  final Duration interval;

  const HabbitModel({
    required this.id,
    required this.name,
    required this.maxStreakLength,
    required this.currentStreakLength,
    required this.interval,
    required this.createdAt,
  });
}
