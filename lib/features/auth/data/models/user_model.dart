import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String name,
    required String role,
    String? profileImage,
    required DateTime createdAt,
    @Default(false) bool isEmailVerified,
  }) = _UserModel;
  
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  User toEntity() => User(
    id: id,
    email: email,
    name: name,
    role: role,
    profileImage: profileImage,
    createdAt: createdAt,
    isEmailVerified: isEmailVerified,
  );
}

extension UserX on User {
  UserModel toModel() => UserModel(
    id: id,
    email: email,
    name: name,
    role: role,
    profileImage: profileImage,
    createdAt: createdAt,
    isEmailVerified: isEmailVerified,
  );
}


