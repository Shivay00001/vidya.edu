import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/voice_validation_result.dart';
import '../../domain/usecases/validate_answer_usecase.dart';
import '../../data/repositories/voice_validation_repository_impl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Repository Provider
final voiceValidationRepositoryProvider = Provider((ref) {
  final apiClient = ref.read(apiClientProvider);
  return VoiceValidationRepositoryImpl(apiClient);
});

// Use Case Provider
final validateAnswerUseCaseProvider = Provider((ref) {
  return ValidateAnswerUseCase(ref.read(voiceValidationRepositoryProvider));
});

// Voice State
class VoiceValidationState {
  final bool isListening;
  final String currentTranscription;
  final VoiceValidationResult? result;
  final bool isLoading;
  final String? error;

  VoiceValidationState({
    this.isListening = false,
    this.currentTranscription = '',
    this.result,
    this.isLoading = false,
    this.error,
  });

  VoiceValidationState copyWith({
    bool? isListening,
    String? currentTranscription,
    VoiceValidationResult? result,
    bool? isLoading,
    String? error,
  }) {
    return VoiceValidationState(
      isListening: isListening ?? this.isListening,
      currentTranscription: currentTranscription ?? this.currentTranscription,
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notifier
class VoiceValidationNotifier extends StateNotifier<VoiceValidationState> {
  final ValidateAnswerUseCase validateAnswerUseCase;
  final VoiceValidationRepositoryImpl repository;

  VoiceValidationNotifier({
    required this.validateAnswerUseCase,
    required this.repository,
  }) : super(VoiceValidationState());

  Future<void> startListening() async {
    state = state.copyWith(isListening: true, currentTranscription: '', result: null);
    final result = await repository.startListening();
    result.fold(
      (failure) => state = state.copyWith(isListening: false, error: failure.message),
      (msg) => state = state.copyWith(currentTranscription: msg),
    );
  }

  Future<void> stopAndValidate(String questionId, String expectedAnswer) async {
    state = state.copyWith(isListening: false, isLoading: true);
    await repository.stopListening();

    final result = await validateAnswerUseCase(
      questionId: questionId,
      expectedAnswer: expectedAnswer,
      audioPath: 'mock_path.wav',
    );

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (validationResult) => state = state.copyWith(isLoading: false, result: validationResult),
    );
  }

  void reset() {
    state = VoiceValidationState();
  }
}

// Provider
final voiceValidationProvider =
    StateNotifierProvider<VoiceValidationNotifier, VoiceValidationState>((ref) {
  return VoiceValidationNotifier(
    validateAnswerUseCase: ref.read(validateAnswerUseCaseProvider),
    repository: ref.read(voiceValidationRepositoryProvider),
  );
});

