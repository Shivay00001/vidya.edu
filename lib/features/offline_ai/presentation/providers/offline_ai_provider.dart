import '../../../auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/offline_ai_model.dart';
import '../../data/repositories/offline_ai_repository_impl.dart';

// Repository Provider
final offlineAiRepositoryProvider = Provider((ref) => OfflineAiRepositoryImpl(ref.read(apiClientProvider)));

// State
class OfflineAiState {
  final List<OfflineAiModel> availableModels;
  final bool isOfflineModeEnabled;
  final bool isLoading;
  final String? error;

  OfflineAiState({
    this.availableModels = const [],
    this.isOfflineModeEnabled = false,
    this.isLoading = false,
    this.error,
  });

  OfflineAiState copyWith({
    List<OfflineAiModel>? availableModels,
    bool? isOfflineModeEnabled,
    bool? isLoading,
    String? error,
  }) {
    return OfflineAiState(
      availableModels: availableModels ?? this.availableModels,
      isOfflineModeEnabled: isOfflineModeEnabled ?? this.isOfflineModeEnabled,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notifier
class OfflineAiNotifier extends StateNotifier<OfflineAiState> {
  final OfflineAiRepositoryImpl repository;

  OfflineAiNotifier({required this.repository}) : super(OfflineAiState());

  Future<void> loadModels() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await repository.getAvailableModels();

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (models) => state = state.copyWith(isLoading: false, availableModels: models),
    );
  }

  void toggleOfflineMode(bool enabled) {
    state = state.copyWith(isOfflineModeEnabled: enabled);
  }

  Future<void> downloadModel(String modelId) async {
    // In a real app, this would update progress
    await repository.downloadModel(modelId);
    await loadModels(); // Refresh state
  }
}

// Provider
final offlineAiProvider =
    StateNotifierProvider<OfflineAiNotifier, OfflineAiState>((ref) {
  return OfflineAiNotifier(
    repository: ref.read(offlineAiRepositoryProvider),
  );
});

