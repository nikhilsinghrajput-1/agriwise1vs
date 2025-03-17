import 'package:myapp/src/core/repositories/base_repository.dart';
import 'package:myapp/src/features/authentication/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Result<User>> signIn(String email, String password);
  Future<Result<User>> signUp(String name, String email, String password, String phone);
  Future<Result<bool>> signOut();
  Future<Result<User?>> getCurrentUser();
  Future<Result<bool>> resetPassword(String email);
}
