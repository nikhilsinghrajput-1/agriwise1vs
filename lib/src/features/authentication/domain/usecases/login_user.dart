import 'package:myapp/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:myapp/src/features/authentication/domain/entities/user.dart';

class LoginUser {
  final AuthRepository authRepository;

  LoginUser({required this.authRepository});

  Future<User> execute(String username, String password) async {
    final result = await authRepository.signIn(username, password);
    if (result.isSuccess && result.data != null) {
      return result.data!;
    } else {
      throw Exception('Failed to login');
    }
  }
}
