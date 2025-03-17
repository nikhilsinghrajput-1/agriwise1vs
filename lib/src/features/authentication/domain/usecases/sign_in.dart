import 'package:myapp/src/core/repositories/base_repository.dart';
import 'package:myapp/src/features/authentication/domain/entities/user.dart';
import 'package:myapp/src/features/authentication/domain/repositories/auth_repository.dart';

class SignIn {
  final AuthRepository repository;

  SignIn({required this.repository});

  Future<Result<User>> execute(String email, String password) async {
    return await repository.signIn(email, password);
  }
} 