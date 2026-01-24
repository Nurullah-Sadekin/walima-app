import 'package:flutter_boilerplate/features/home/domain/entities/user.dart';
import 'package:flutter_boilerplate/features/home/domain/repositories/user_repository.dart';

/// Get user use case
class GetUserUseCase {
  final UserRepository repository;

  const GetUserUseCase(this.repository);

  Future<User?> call(String id) async {
    return await repository.getUser(id);
  }
}
