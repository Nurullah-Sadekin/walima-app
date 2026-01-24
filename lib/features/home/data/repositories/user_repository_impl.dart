import 'package:flutter_boilerplate/features/home/data/datasources/user_remote_datasource.dart';
import 'package:flutter_boilerplate/features/home/data/models/user_model.dart';
import 'package:flutter_boilerplate/features/home/domain/entities/user.dart';
import 'package:flutter_boilerplate/features/home/domain/repositories/user_repository.dart';

/// User repository implementation
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  const UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<User?> getUser(String id) async {
    final userModel = await _remoteDataSource.getUser(id);
    return userModel?.toEntity();
  }

  @override
  Future<List<User>> getUsers() async {
    final userModels = await _remoteDataSource.getUsers();
    return userModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<User> createUser(User user) async {
    final userModel = UserModel.fromEntity(user);
    final createdModel = await _remoteDataSource.createUser(userModel);
    if (createdModel == null) {
      throw Exception('Failed to create user');
    }
    return createdModel.toEntity();
  }

  @override
  Future<User> updateUser(User user) async {
    final userModel = UserModel.fromEntity(user);
    final updatedModel = await _remoteDataSource.updateUser(userModel);
    if (updatedModel == null) {
      throw Exception('Failed to update user');
    }
    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteUser(String id) async {
    final success = await _remoteDataSource.deleteUser(id);
    if (!success) {
      throw Exception('Failed to delete user');
    }
  }
}
