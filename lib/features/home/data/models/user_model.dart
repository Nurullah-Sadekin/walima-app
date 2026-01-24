import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_boilerplate/features/home/domain/entities/user.dart';

part 'user_model.g.dart';

/// User model for data layer
@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String email;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Convert to entity
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
    );
  }

  /// Create from entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
    );
  }
}
