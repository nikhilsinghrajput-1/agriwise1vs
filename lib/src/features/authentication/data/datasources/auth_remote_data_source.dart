import 'package:myapp/src/core/network/api_client.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource({required this.apiClient});

  Future<dynamic> login(String username, String password) async {
    try {
      final response = await apiClient.post(
        '/auth/login',
        body: {'username': username, 'password': password},
      );
      return response;
    } catch (e) {
      throw Exception('Failed to login');
    }
  }

  Future<dynamic> signup(String username, String password, String email) async {
    try {
      final response = await apiClient.post(
        '/auth/signup',
        body: {'username': username, 'password': password, 'email': email},
      );
      return response;
    } catch (e) {
      throw Exception('Failed to signup');
    }
  }
}
