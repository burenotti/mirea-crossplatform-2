import 'package:practice2/features/entities/achievement.dart';

abstract class AchievementsStore {
  List<Achievement> getAllAchievements();
  Stream<List<Achievement>> watchAchievements();
  List<Achievement> getUnlockedAchievements();
  List<Achievement> getLockedAchievements();
}
