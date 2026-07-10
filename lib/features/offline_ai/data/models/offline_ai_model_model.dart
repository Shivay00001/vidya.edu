import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/offline_ai_model.dart';

part 'offline_ai_model_model.freezed.dart';
part 'offline_ai_model_model.g.dart';

@freezed
abstract class OfflineAiModelModel with _$OfflineAiModelModel {
  const factory OfflineAiModelModel({
    required String id,
    required String name,
    required String description,
    required double sizeInMB,
    @Default(false) bool isDownloaded,
    @Default(0.0) double downloadProgress,
    String? localPath,
  }) = _OfflineAiModelModel;

  factory OfflineAiModelModel.fromJson(Map<String, dynamic> json) =>
      _$OfflineAiModelModelFromJson(json);
}

extension OfflineAiModelModelX on OfflineAiModelModel {
  OfflineAiModel toEntity() => OfflineAiModel(
        id: this.id,
        name: this.name,
        description: this.description,
        sizeInMB: this.sizeInMB,
        isDownloaded: this.isDownloaded,
        downloadProgress: this.downloadProgress,
        localPath: this.localPath,
      );
}

