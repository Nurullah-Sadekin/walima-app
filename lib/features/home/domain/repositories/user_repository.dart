import 'package:flutter_boilerplate/features/home/domain/entities/user.dart';

/// User repository interface
abstract class UserRepository {
  Future<User?> getUser(String id);
  Future<List<User>> getUsers();
  Future<User> createUser(User user);
  Future<User> updateUser(User user);
  Future<void> deleteUser(String id);
}
