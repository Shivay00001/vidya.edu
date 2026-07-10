import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/repositories/gamification_repository.dart';
import '../models/achievement_model.dart';
import '../models/achievement_model.dart';

class GamificationRepositoryImpl implements GamificationRepository {
  final ApiClient _apiClient;

  GamificationRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, List<Achievement>>> getAchievements() async {
    try {
      final response = await _apiClient.get(ApiConstants.achievements);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<Achievement> achievements = data
            .map((e) => AchievementModel.fromJson(e).toEntity())
            .toList();
        return Right(achievements);
      } else {
        return const Left(ServerFailure('Failed to fetch achievements'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Badge>>> getBadges() async {
    try {
      final response = await _apiClient.get(ApiConstants.badges);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<Badge> badges = data
            .map((e) => BadgeModel.fromJson(e).toEntity())
            .toList();
        return Right(badges);
      } else {
        return const Left(ServerFailure('Failed to fetch badges'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unlockAchievement(String achievementId) async {
    return const Right(null);
  }
}

