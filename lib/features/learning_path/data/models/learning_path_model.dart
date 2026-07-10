import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/learning_path.dart';

part 'learning_path_model.freezed.dart';
part 'learning_path_model.g.dart';

@freezed
abstract class LearningPathModel with _$LearningPathModel {
  const factory LearningPathModel({
    required String id,
    required String title,
    required String description,
    required List<LessonModel> lessons,
    @Default(0.0) double progress,
  }) = _LearningPathModel;

  factory LearningPathModel.fromJson(Map<String, dynamic> json) =>
      _$LearningPathModelFromJson(json);
}

@freezed
abstract class LessonModel with _$LessonModel {
  const factory LessonModel({
    required String id,
    required String title,
    required String content,
    required LessonType type,
    @Default(false) bool isCompleted,
    List<String>? quizQuestionIds,
  }) = _LessonModel;

  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      _$LessonModelFromJson(json);
}

extension LearningPathModelX on LearningPathModel {
  LearningPath toEntity() => LearningPath(
        id: id,
        title: title,
        description: description,
        lessons: lessons.map((e) => e.toEntity()).toList(),
        progress: progress,
      );
}

extension LessonModelX on LessonModel {
  Lesson toEntity() => Lesson(
        id: id,
        title: title,
        content: content,
        type: type,
        isCompleted: isCompleted,
        quizQuestionIds: quizQuestionIds,
      );
}


