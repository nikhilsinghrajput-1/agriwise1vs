import 'package:myapp/src/core/network/api_client.dart';

class ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSource({required this.apiClient});

  Future<dynamic> getProfile() async {
    try {
      final response = await apiClient.get('/profile');
      return response;
    } catch (e) {
      throw Exception('Failed to load profile');
    }
  }

  Future<dynamic> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await apiClient.post('/profile/update', body: profileData);
      return response;
    } catch (e) {
      throw Exception('Failed to update profile');
    }
  }
}
