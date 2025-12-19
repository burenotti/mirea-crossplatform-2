import 'package:practice2/features/entities/achievement.dart';

abstract class AchievementsState {}

class AchievementsInitial extends AchievementsState {}

class AchievementsLoading extends AchievementsState {}

class AchievementsLoaded extends AchievementsState {
  final List<Achievement> achievements;
  final List<Achievement> unlocked;
  final List<Achievement> locked;
  final Achievement? newlyUnlocked;

  AchievementsLoaded({
    required this.achievements,
    required this.unlocked,
    required this.locked,
    this.newlyUnlocked,
  });
}

class AchievementsError extends AchievementsState {
  final String message;

  AchievementsError(this.message);
}
