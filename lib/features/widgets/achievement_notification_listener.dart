import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice2/features/blocs/achievements/achievements_bloc.dart';
import 'package:practice2/features/blocs/achievements/achievements_state.dart';

class AchievementNotificationListener extends StatelessWidget {
  final Widget child;

  const AchievementNotificationListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (builderContext) {
        return BlocListener<AchievementsBloc, AchievementsState>(
          listener: (listenerContext, state) {
            if (state is AchievementsLoaded && state.newlyUnlocked != null) {
              final achievement = state.newlyUnlocked!;

              ScaffoldMessenger.of(builderContext).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Text(
                        achievement.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Достижение открыто!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              achievement.title,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.emoji_events, color: Colors.amber),
                    ],
                  ),
                  backgroundColor: Colors.green[700],
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          },
          child: child,
        );
      },
    );
  }
}
