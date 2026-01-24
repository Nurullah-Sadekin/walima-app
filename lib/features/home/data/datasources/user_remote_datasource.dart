import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/home/data/models/user_model.dart';

/// Remote data source for user-related API calls
class UserRemoteDataSource {
  final DioClient _dioClient;

  const UserRemoteDataSource(this._dioClient);

  /// Get user by ID
  Future<UserModel?> getUser(String id) async {
    final response = await _dioClient.get('/users/$id');

    if (response.isSuccess && response.data != null) {
      return UserModel.fromJson(response.data);
    }
    return null;
  }

  /// Get all users
  Future<List<UserModel>> getUsers() async {
    final response = await _dioClient.get('/users');

    if (response.isSuccess && response.data != null) {
      final List<dynamic> data = response.data;
      return data.map((json) => UserModel.fromJson(json)).toList();
    }
    return [];
  }

  /// Create user
  Future<UserModel?> createUser(UserModel user) async {
    final response = await _dioClient.post(
      '/users',
      data: user.toJson(),
    );

    if (response.isSuccess && response.data != null) {
      return UserModel.fromJson(response.data);
    }
    return null;
  }

  /// Update user
  Future<UserModel?> updateUser(UserModel user) async {
    final response = await _dioClient.put(
      '/users/${user.id}',
      data: user.toJson(),
    );

    if (response.isSuccess && response.data != null) {
      return UserModel.fromJson(response.data);
    }
    return null;
  }

  /// Delete user
  Future<bool> deleteUser(String id) async {
    final response = await _dioClient.delete('/users/$id');
    return response.isSuccess;
  }
}
