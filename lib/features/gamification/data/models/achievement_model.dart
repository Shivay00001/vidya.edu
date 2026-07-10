import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/achievement.dart';

part 'achievement_model.freezed.dart';
part 'achievement_model.g.dart';

@freezed
abstract class AchievementModel with _$AchievementModel {
  const factory AchievementModel({
    required String id,
    required String title,
    required String description,
    required String iconUrl,
    @Default(false) bool isUnlocked,
    DateTime? unlockedAt,
  }) = _AchievementModel;

  factory AchievementModel.fromJson(Map<String, dynamic> json) =>
      _$AchievementModelFromJson(json);
}

@freezed
abstract class BadgeModel with _$BadgeModel {
  const factory BadgeModel({
    required String id,
    required String name,
    required String imageUrl,
    required String criteria,
  }) = _BadgeModel;

  factory BadgeModel.fromJson(Map<String, dynamic> json) =>
      _$BadgeModelFromJson(json);
}

extension AchievementModelX on AchievementModel {
  Achievement toEntity() => Achievement(
        id: id,
        title: title,
        description: description,
        iconUrl: iconUrl,
        isUnlocked: isUnlocked,
        unlockedAt: unlockedAt,
      );
}

extension BadgeModelX on BadgeModel {
  Badge toEntity() => Badge(
        id: id,
        name: name,
        imageUrl: imageUrl,
        criteria: criteria,
      );
}


