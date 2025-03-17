import 'package:myapp/src/core/repositories/base_repository.dart';
import 'package:myapp/src/features/authentication/domain/repositories/auth_repository.dart';

class ResetPassword {
  final AuthRepository repository;

  ResetPassword({required this.repository});

  Future<Result<bool>> execute(String email) async {
    return await repository.resetPassword(email);
  }
} 