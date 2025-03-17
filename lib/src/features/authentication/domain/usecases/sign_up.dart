import 'package:myapp/src/core/repositories/base_repository.dart';
import 'package:myapp/src/features/authentication/domain/entities/user.dart';
import 'package:myapp/src/features/authentication/domain/repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp({required this.repository});

  Future<Result<User>> execute(String name, String email, String password, String phone) async {
    return await repository.signUp(name, email, password, phone);
  }
} 