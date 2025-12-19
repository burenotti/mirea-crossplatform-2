import 'package:practice2/features/entities/app_action.dart';

enum AchievementCategory {
  habits,
  dedication,
  exploration,
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final AchievementCategory category;
  final int targetCount;
  final int currentProgress;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final ActionType triggerAction;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.targetCount,
    required this.currentProgress,
    required this.isUnlocked,
    this.unlockedAt,
    required this.triggerAction,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    AchievementCategory? category,
    int? targetCount,
    int? currentProgress,
    bool? isUnlocked,
    DateTime? unlockedAt,
    ActionType? triggerAction,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      targetCount: targetCount ?? this.targetCount,
      currentProgress: currentProgress ?? this.currentProgress,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      triggerAction: triggerAction ?? this.triggerAction,
    );
  }

  double get progressPercentage {
    if (isUnlocked) return 1.0;
    return (currentProgress / targetCount).clamp(0.0, 1.0);
  }
}
