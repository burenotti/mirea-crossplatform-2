import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice2/features/blocs/achievements/achievements_bloc.dart';
import 'package:practice2/features/blocs/achievements/achievements_state.dart';
import 'package:practice2/features/entities/achievement.dart';
import 'package:practice2/features/widgets/app_drawer.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AchievementsView();
  }
}

class _AchievementsView extends StatelessWidget {
  const _AchievementsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Достижения'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const AppDrawer(),
      body: BlocBuilder<AchievementsBloc, AchievementsState>(
        builder: (context, state) {
          if (state is AchievementsInitial || state is AchievementsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AchievementsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                ],
              ),
            );
          }

          if (state is AchievementsLoaded) {
            return DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  _AchievementsStats(state: state),
                  const TabBar(
                    tabs: [
                      Tab(text: 'Все'),
                      Tab(text: 'Открытые'),
                      Tab(text: 'Закрытые'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _AchievementsList(achievements: state.achievements),
                        _AchievementsList(achievements: state.unlocked),
                        _AchievementsList(achievements: state.locked),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _AchievementsStats extends StatelessWidget {
  final AchievementsLoaded state;

  const _AchievementsStats({required this.state});

  @override
  Widget build(BuildContext context) {
    final unlockedCount = state.unlocked.length;
    final totalCount = state.achievements.length;
    final percentage = (unlockedCount / totalCount * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: Icons.emoji_events,
            label: 'Открыто',
            value: '$unlockedCount/$totalCount',
          ),
          _StatItem(
            icon: Icons.percent,
            label: 'Прогресс',
            value: '$percentage%',
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _AchievementsList extends StatelessWidget {
  final List<Achievement> achievements;

  const _AchievementsList({required this.achievements});

  @override
  Widget build(BuildContext context) {
    if (achievements.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Пока нет достижений'),
          ],
        ),
      );
    }

    // Группируем по категориям
    final byCategory = <AchievementCategory, List<Achievement>>{};
    for (final achievement in achievements) {
      byCategory.putIfAbsent(achievement.category, () => []).add(achievement);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final category in byCategory.keys)
          _CategorySection(
            category: category,
            achievements: byCategory[category]!,
          ),
      ],
    );
  }
}

class _CategorySection extends StatelessWidget {
  final AchievementCategory category;
  final List<Achievement> achievements;

  const _CategorySection({
    required this.category,
    required this.achievements,
  });

  String get categoryName {
    switch (category) {
      case AchievementCategory.habits:
        return 'Привычки';
      case AchievementCategory.dedication:
        return 'Целеустремленность';
      case AchievementCategory.exploration:
        return 'Исследование';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            categoryName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...achievements.map((achievement) => _AchievementCard(
              achievement: achievement,
            )),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = achievement.isUnlocked;
    final progress = achievement.progressPercentage;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isUnlocked ? 4 : 1,
      child: Opacity(
        opacity: isUnlocked ? 1.0 : 0.6,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Иконка
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    achievement.icon,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Информация
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            achievement.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        if (isUnlocked)
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      achievement.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    // Прогресс бар
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${achievement.currentProgress}/${achievement.targetCount}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isUnlocked
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
