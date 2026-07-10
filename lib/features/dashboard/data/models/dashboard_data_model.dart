import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/dashboard_data.dart';

part 'dashboard_data_model.freezed.dart';
part 'dashboard_data_model.g.dart';

@freezed
abstract class DashboardDataModel with _$DashboardDataModel {
  const factory DashboardDataModel({
    required int completedCourses,
    required int totalLessons,
    required double learningProgress,
    required int totalXP,
    required int currentStreak,
    required String currentRank,
    required List<RecentActivityModel> recentActivities,
  }) = _DashboardDataModel;

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataModelFromJson(json);
}

@freezed
abstract class RecentActivityModel with _$RecentActivityModel {
  const factory RecentActivityModel({
    required String id,
    required String title,
    required String type,
    required DateTime timestamp,
  }) = _RecentActivityModel;

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) =>
      _$RecentActivityModelFromJson(json);
}

extension DashboardDataModelX on DashboardDataModel {
  DashboardData toEntity() => DashboardData(
        completedCourses: this.completedCourses,
        totalLessons: this.totalLessons,
        learningProgress: this.learningProgress,
        totalXP: this.totalXP,
        currentStreak: this.currentStreak,
        currentRank: this.currentRank,
        recentActivities: this.recentActivities.map((e) => e.toEntity()).toList(),
      );
}

extension RecentActivityModelX on RecentActivityModel {
  RecentActivity toEntity() => RecentActivity(
        id: this.id,
        title: this.title,
        type: this.type,
        timestamp: this.timestamp,
      );
}


