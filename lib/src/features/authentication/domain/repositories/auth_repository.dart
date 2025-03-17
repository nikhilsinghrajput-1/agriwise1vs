import 'package:myapp/src/features/authentication/domain/entities/user.dart';



abstract class AuthRepository {
  Future<UserProfile> login(String username, String password);
  Future<UserProfile> signup(String username, String password, String email);
}
