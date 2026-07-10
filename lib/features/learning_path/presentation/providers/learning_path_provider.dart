import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/learning_path.dart';
import '../../domain/usecases/get_personalized_path_usecase.dart';
import '../../data/repositories/learning_path_repository_impl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Repository Provider
final learningPathRepositoryProvider = Provider((ref) {
  final apiClient = ref.read(apiClientProvider);
  return LearningPathRepositoryImpl(apiClient);
});

// Use Case Provider
final getPersonalizedPathUseCaseProvider = Provider((ref) {
  return GetPersonalizedPathUseCase(ref.read(learningPathRepositoryProvider));
});

// Learning Path State
class LearningPathState {
  final LearningPath? path;
  final bool isLoading;
  final String? error;

  LearningPathState({
    this.path,
    this.isLoading = false,
    this.error,
  });

  LearningPathState copyWith({
    LearningPath? path,
    bool? isLoading,
    String? error,
  }) {
    return LearningPathState(
      path: path ?? this.path,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Learning Path Notifier
class LearningPathNotifier extends StateNotifier<LearningPathState> {
  final GetPersonalizedPathUseCase getPersonalizedPathUseCase;

  LearningPathNotifier({required this.getPersonalizedPathUseCase})
      : super(LearningPathState());

  Future<void> loadLearningPath() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await getPersonalizedPathUseCase();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (path) {
        state = state.copyWith(
          isLoading: false,
          path: path,
          error: null,
        );
      },
    );
  }
}

// Provider
final learningPathProvider =
    StateNotifierProvider<LearningPathNotifier, LearningPathState>((ref) {
  return LearningPathNotifier(
    getPersonalizedPathUseCase: ref.read(getPersonalizedPathUseCaseProvider),
  );
});

