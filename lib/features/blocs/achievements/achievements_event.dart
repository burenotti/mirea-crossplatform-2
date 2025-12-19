import 'package:practice2/features/entities/achievement.dart';

abstract class AchievementsEvent {}

class LoadAchievements extends AchievementsEvent {}

class AchievementsUpdated extends AchievementsEvent {
  final List<Achievement> achievements;

  AchievementsUpdated(this.achievements);
}
