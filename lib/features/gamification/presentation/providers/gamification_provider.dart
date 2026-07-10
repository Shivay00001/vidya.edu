import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/usecases/get_achievements_usecase.dart';
import '../../data/repositories/gamification_repository_impl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Repository Provider
final gamificationRepositoryProvider = Provider((ref) {
  final apiClient = ref.read(apiClientProvider);
  return GamificationRepositoryImpl(apiClient);
});

// Use Case Provider
final getAchievementsUseCaseProvider = Provider((ref) {
  return GetAchievementsUseCase(ref.read(gamificationRepositoryProvider));
});

// Gamification State
class GamificationState {
  final List<Achievement> achievements;
  final List<Badge> badges;
  final bool isLoading;
  final String? error;

  GamificationState({
    this.achievements = const [],
    this.badges = const [],
    this.isLoading = false,
    this.error,
  });

  GamificationState copyWith({
    List<Achievement>? achievements,
    List<Badge>? badges,
    bool? isLoading,
    String? error,
  }) {
    return GamificationState(
      achievements: achievements ?? this.achievements,
      badges: badges ?? this.badges,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Gamification Notifier
class GamificationNotifier extends StateNotifier<GamificationState> {
  final GetAchievementsUseCase getAchievementsUseCase;
  final GamificationRepositoryImpl repository;

  GamificationNotifier({
    required this.getAchievementsUseCase,
    required this.repository,
  }) : super(GamificationState());

  Future<void> loadGamificationData() async {
    state = state.copyWith(isLoading: true, error: null);

    final achievementsResult = await getAchievementsUseCase();
    final badgesResult = await repository.getBadges();

    achievementsResult.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (achievements) {
        badgesResult.fold(
          (failure) => state = state.copyWith(isLoading: false, error: failure.message),
          (badges) {
            state = state.copyWith(
              isLoading: false,
              achievements: achievements,
              badges: badges,
              error: null,
            );
          },
        );
      },
    );
  }
}

// Provider
final gamificationProvider =
    StateNotifierProvider<GamificationNotifier, GamificationState>((ref) {
  return GamificationNotifier(
    getAchievementsUseCase: ref.read(getAchievementsUseCaseProvider),
    repository: ref.read(gamificationRepositoryProvider),
  );
});

