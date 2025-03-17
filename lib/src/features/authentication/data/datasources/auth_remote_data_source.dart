import 'package:myapp/src/core/errors/exceptions.dart';
import 'package:myapp/src/core/network/api_client.dart';
import 'package:myapp/src/features/authentication/data/models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource({required this.apiClient});

  Future<UserModel> signIn(String email, String password) async {
    try {
      final response = await apiClient.post(
        '/auth/login',
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response['success'] == true) {
        return UserModel.fromJson(response['user']);
      } else {
        throw ServerException(
          message: response['message'] ?? 'Failed to sign in',
        );
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Failed to sign in');
    }
  }

  Future<UserModel> signUp(String name, String email, String password, String phone) async {
    try {
      final response = await apiClient.post(
        '/auth/register',
        body: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
        },
      );

      if (response['success'] == true) {
        return UserModel.fromJson(response['user']);
      } else {
        throw ServerException(
          message: response['message'] ?? 'Failed to sign up',
        );
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Failed to sign up');
    }
  }

  Future<void> signOut() async {
    try {
      await apiClient.post('/auth/logout');
    } catch (e) {
      throw ServerException(message: 'Failed to sign out');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await apiClient.get('/auth/me');
      
      if (response['success'] == true && response['user'] != null) {
        return UserModel.fromJson(response['user']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      final response = await apiClient.post(
        '/auth/reset-password',
        body: {
          'email': email,
        },
      );

      if (response['success'] != true) {
        throw ServerException(
          message: response['message'] ?? 'Failed to reset password',
        );
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Failed to reset password');
    }
  }
}
