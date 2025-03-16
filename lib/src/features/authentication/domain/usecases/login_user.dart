import 'package:myapp/src/features/authentication/domain/entities/user.dart';
import 'package:myapp/src/features/authentication/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository authRepository;

  LoginUser({required this.authRepository});

  Future<UserProfile> execute(String username, String password) async {
    return await authRepository.login(username, password);
  }
}
