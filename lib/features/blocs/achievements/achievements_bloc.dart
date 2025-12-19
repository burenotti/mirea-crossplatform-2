import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:practice2/features/blocs/achievements/achievements_event.dart';
import 'package:practice2/features/blocs/achievements/achievements_state.dart';
import 'package:practice2/features/entities/achievement.dart';
import 'package:practice2/features/stores/achievements_store.dart';

class AchievementsBloc extends Bloc<AchievementsEvent, AchievementsState> {
  final AchievementsStore achievementsStore;
  StreamSubscription? _achievementsSubscription;
  List<Achievement> _previousAchievements = [];

  AchievementsBloc({required this.achievementsStore})
      : super(AchievementsInitial()) {
    on<LoadAchievements>(_onLoadAchievements);
    on<AchievementsUpdated>(_onAchievementsUpdated);

    _achievementsSubscription =
        achievementsStore.watchAchievements().listen((achievements) {
      add(AchievementsUpdated(achievements));
    });
  }

  void _onLoadAchievements(
      LoadAchievements event, Emitter<AchievementsState> emit) {
    emit(AchievementsLoading());

    try {
      final achievements = achievementsStore.getAllAchievements();
      _previousAchievements = achievements;
      final unlocked = achievementsStore.getUnlockedAchievements();
      final locked = achievementsStore.getLockedAchievements();

      emit(AchievementsLoaded(
        achievements: achievements,
        unlocked: unlocked,
        locked: locked,
      ));
    } catch (e) {
      emit(AchievementsError('Не удалось загрузить достижения'));
    }
  }

  void _onAchievementsUpdated(
      AchievementsUpdated event, Emitter<AchievementsState> emit) {
    final unlocked = event.achievements.where((a) => a.isUnlocked).toList();
    final locked = event.achievements.where((a) => !a.isUnlocked).toList();

    // Находим новую открытую ачивку
    Achievement? newlyUnlocked;
    for (final achievement in event.achievements) {
      if (achievement.isUnlocked) {
        final previous = _previousAchievements
            .where((a) => a.id == achievement.id)
            .firstOrNull;
        if (previous != null && !previous.isUnlocked) {
          newlyUnlocked = achievement;
          break;
        }
      }
    }

    _previousAchievements = event.achievements;

    emit(AchievementsLoaded(
      achievements: event.achievements,
      unlocked: unlocked,
      locked: locked,
      newlyUnlocked: newlyUnlocked,
    ));
  }

  @override
  Future<void> close() {
    _achievementsSubscription?.cancel();
    return super.close();
  }
}
