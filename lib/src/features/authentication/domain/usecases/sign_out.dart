import 'package:myapp/src/core/repositories/base_repository.dart';
import 'package:myapp/src/features/authentication/domain/repositories/auth_repository.dart';

class SignOut {
  final AuthRepository repository;

  SignOut({required this.repository});

  Future<Result<bool>> execute() async {
    return await repository.signOut();
  }
} 