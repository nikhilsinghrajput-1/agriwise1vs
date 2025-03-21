import '../../domain/models/crop_health_model.dart';
import '../../domain/repositories/crop_health_repository.dart';
import 'package:myapp/src/core/network/api_client.dart';
import 'package:myapp/src/core/network/connectivity_service.dart';

class CropHealthRepositoryImpl implements CropHealthRepository {
  final ApiClient _apiClient;
  final ConnectivityService _connectivityService;

  CropHealthRepositoryImpl(this._apiClient, this._connectivityService);

  @override
  Future<List<CropHealth>> getCropHealthHistory(String cropId) async {
    if (!await _connectivityService.hasInternetConnection()) {
      throw Exception('No internet connection');
    }

    final response = await _apiClient.get('/crops/$cropId/health');
final List<dynamic> data = response['records'];
    return data.map((json) => CropHealth.fromJson(json)).toList();
  }

  @override
  Future<CropHealth> addCropHealthRecord(CropHealth record) async {
    if (!await _connectivityService.hasInternetConnection()) {
      throw Exception('No internet connection');
    }

    final response = await _apiClient.post(
      '/crops/${record.cropId}/health',
      body: record.toJson(),
    );
return CropHealth.fromJson(response);
  }

  @override
  Future<void> deleteCropHealthRecord(String recordId) async {
    if (!await _connectivityService.hasInternetConnection()) {
      throw Exception('No internet connection');
    }

    await _apiClient.delete('/crop-health/$recordId');
  }

  @override
  Stream<List<CropHealth>> watchCropHealthHistory(String cropId) {
    // TODO: Implement watchCropHealthHistory
    return Stream.empty();
  }
}
