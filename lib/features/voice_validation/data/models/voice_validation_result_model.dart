import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/voice_validation_result.dart';

part 'voice_validation_result_model.freezed.dart';
part 'voice_validation_result_model.g.dart';

@freezed
abstract class VoiceValidationResultModel with _$VoiceValidationResultModel {
  const factory VoiceValidationResultModel({
    required bool isCorrect,
    required double confidenceScore,
    required String transcription,
    required String feedback,
    List<String>? suggestions,
  }) = _VoiceValidationResultModel;

  factory VoiceValidationResultModel.fromJson(Map<String, dynamic> json) =>
      _$VoiceValidationResultModelFromJson(json);
}

extension VoiceValidationResultModelX on VoiceValidationResultModel {
  VoiceValidationResult toEntity() => VoiceValidationResult(
        isCorrect: isCorrect,
        confidenceScore: confidenceScore,
        transcription: transcription,
        feedback: feedback,
        suggestions: suggestions,
      );
}

