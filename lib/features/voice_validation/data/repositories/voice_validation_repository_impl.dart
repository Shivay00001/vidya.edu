import 'package:dartz/dartz.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/voice_validation_result.dart';
import '../../domain/repositories/voice_validation_repository.dart';
import '../models/voice_validation_result_model.dart';

class VoiceValidationRepositoryImpl implements VoiceValidationRepository {
  final ApiClient _apiClient;
  final SpeechToText _speechToText = SpeechToText();

  VoiceValidationRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, VoiceValidationResult>> validateAnswer({
    required String questionId,
    required String expectedAnswer,
    required String audioPath,
  }) async {
    try {
      // In a real scenario, we might send the audioPath or a transcription to the server.
      // Here we assume the server takes the expected answer and user's transcription (which would be passed differently in a real API).
      final response = await _apiClient.post(
        ApiConstants.voiceValidation,
        data: {
          'question_id': questionId,
          'expected_answer': expectedAnswer,
          'transcription': audioPath, // Using audioPath as a placeholder for the transcribed text in this context
        },
      );

      if (response.statusCode == 200) {
        final model = VoiceValidationResultModel.fromJson(response.data);
        return Right(model.toEntity());
      } else {
        return const Left(ServerFailure('Voice validation failed'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> startListening() async {
    try {
      bool available = await _speechToText.initialize();
      if (available) {
        String transcription = "";
        _speechToText.listen(
          onResult: (result) {
            transcription = result.recognizedWords;
          },
        );
        return Right(transcription);
      } else {
        return const Left(UnknownFailure('Speech recognition not available'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> stopListening() async {
    await _speechToText.stop();
  }
}

