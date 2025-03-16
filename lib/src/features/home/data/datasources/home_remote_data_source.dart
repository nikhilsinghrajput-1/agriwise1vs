import 'package:myapp/src/core/network/api_client.dart';

class HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSource({required this.apiClient});

  Future<dynamic> getAdvisories() async {
    try {
      final response = await apiClient.get('/advisories');
      return response;
    } catch (e) {
      throw Exception('Failed to load advisories');
    }
  }
}
