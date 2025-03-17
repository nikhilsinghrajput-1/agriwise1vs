import 'package:myapp/src/core/repositories/base_repository.dart';
import 'package:myapp/src/features/authentication/domain/entities/user.dart';
import 'package:myapp/src/features/authentication/domain/repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser({required this.repository});

  Future<Result<User?>> execute() async {
    return await repository.getCurrentUser();
  }
} 