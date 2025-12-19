import 'dart:async';
import 'package:practice2/features/entities/achievement.dart';
import 'package:practice2/features/entities/app_action.dart';
import 'package:practice2/features/stores/achievements_store.dart';
import 'package:practice2/features/stores/actions_store.dart';

class AchievementsStoreImpl implements AchievementsStore {
  final ActionsStore actionsStore;
  final _controller = StreamController<List<Achievement>>.broadcast();
  StreamSubscription? _actionsSubscription;

  List<Achievement> _achievements = [];

  AchievementsStoreImpl({required this.actionsStore}) {
    _initializeAchievements();
    _subscribeToActions();
  }

  void _initializeAchievements() {
    _achievements = [
      const Achievement(
        id: 'first_habit',
        title: 'Первый шаг',
        description: 'Создайте свою первую привычку',
        icon: '🌱',
        category: AchievementCategory.habits,
        targetCount: 1,
        currentProgress: 0,
        isUnlocked: false,
        triggerAction: ActionType.habbitCreated,
      ),
      const Achievement(
        id: 'habit_collector',
        title: 'Коллекционер',
        description: 'Создайте 5 привычек',
        icon: '📚',
        category: AchievementCategory.habits,
        targetCount: 5,
        currentProgress: 0,
        isUnlocked: false,
        triggerAction: ActionType.habbitCreated,
      ),
      const Achievement(
        id: 'habit_master',
        title: 'Мастер привычек',
        description: 'Создайте 10 привычек',
        icon: '🏆',
        category: AchievementCategory.habits,
        targetCount: 10,
        currentProgress: 0,
        isUnlocked: false,
        triggerAction: ActionType.habbitCreated,
      ),
      const Achievement(
        id: 'first_ack',
        title: 'Начало пути',
        description: 'Отметьте выполнение привычки впервые',
        icon: '✅',
        category: AchievementCategory.dedication,
        targetCount: 1,
        currentProgress: 0,
        isUnlocked: false,
        triggerAction: ActionType.habbitAcked,
      ),
      const Achievement(
        id: 'dedicated',
        title: 'Целеустремленный',
        description: 'Отметьте выполнение 10 раз',
        icon: '💪',
        category: AchievementCategory.dedication,
        targetCount: 10,
        currentProgress: 0,
        isUnlocked: false,
        triggerAction: ActionType.habbitAcked,
      ),
      const Achievement(
        id: 'unstoppable',
        title: 'Неудержимый',
        description: 'Отметьте выполнение 50 раз',
        icon: '🔥',
        category: AchievementCategory.dedication,
        targetCount: 50,
        currentProgress: 0,
        isUnlocked: false,
        triggerAction: ActionType.habbitAcked,
      ),
      const Achievement(
        id: 'theme_changer',
        title: 'Модный дизайнер',
        description: 'Измените тему приложения',
        icon: '🎨',
        category: AchievementCategory.exploration,
        targetCount: 1,
        currentProgress: 0,
        isUnlocked: false,
        triggerAction: ActionType.themeChanged,
      ),
      const Achievement(
        id: 'support_asker',
        title: 'Любопытный',
        description: 'Задайте вопрос в поддержку',
        icon: '💬',
        category: AchievementCategory.exploration,
        targetCount: 1,
        currentProgress: 0,
        isUnlocked: false,
        triggerAction: ActionType.supportMessageSent,
      ),
    ];
    _controller.add(_achievements);
  }

  void _subscribeToActions() {
    _actionsSubscription = actionsStore.watchActions().listen((action) {
      _handleAction(action);
    });
  }

  void _handleAction(AppAction action) {
    bool hasChanges = false;

    for (var i = 0; i < _achievements.length; i++) {
      final achievement = _achievements[i];

      if (achievement.isUnlocked) continue;
      if (achievement.triggerAction != action.type) continue;

      // Увеличиваем прогресс
      final newProgress = achievement.currentProgress + 1;
      final isNowUnlocked = newProgress >= achievement.targetCount;

      _achievements[i] = achievement.copyWith(
        currentProgress: newProgress,
        isUnlocked: isNowUnlocked,
        unlockedAt: isNowUnlocked ? action.timestamp : null,
      );

      hasChanges = true;
    }

    if (hasChanges) {
      _controller.add(_achievements);
    }
  }

  @override
  List<Achievement> getAllAchievements() {
    return List.unmodifiable(_achievements);
  }

  @override
  Stream<List<Achievement>> watchAchievements() {
    return _controller.stream;
  }

  @override
  List<Achievement> getUnlockedAchievements() {
    return _achievements.where((a) => a.isUnlocked).toList();
  }

  @override
  List<Achievement> getLockedAchievements() {
    return _achievements.where((a) => !a.isUnlocked).toList();
  }

  void dispose() {
    _actionsSubscription?.cancel();
    _controller.close();
  }
}
