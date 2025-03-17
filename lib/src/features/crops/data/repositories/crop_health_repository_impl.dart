import '../../domain/models/crop_health_model.dart';
import '../../domain/repositories/crop_health_repository.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/connectivity_service.dart';

class CropHealthRepositoryImpl implements CropHealthRepository {
  final ApiClient _apiClient;
  final ConnectivityService _connectivityService;

  CropHealthRepositoryImpl(this._apiClient, this._connectivityService);

  @override
  Future<List<CropHealth>> getCropHealthHistory(String cropId) async {
    if (!await _connectivityService.isConnected) {
      throw Exception('No internet connection');
    }

    final response = await _apiClient.get('/crops/$cropId/health');
    final List<dynamic> data = response.data['records'];
    return data.map((json) => CropHealth.fromJson(json)).toList();
  }

  @override
  Future<CropHealth> addCropHealthRecord(CropHealth record) async {
    if (!await _connectivityService.isConnected) {
      throw Exception('No internet connection');
    }

    final response = await _apiClient.post(
      '/crops/${record.cropId}/health',
      data: record.toJson(),
    );
    return CropHealth.fromJson(response.data);
  }

  @override
  Future<void> deleteCropHealthRecord(String recordId) async {
    if (!await _connectivityService.isConnected) {
      throw Exception('No internet connection');
    }

    await _apiClient.delete('/crop-health/$recordId');
  }

  @override
  Stream<List<CropHealth>> watchCropHealthHistory(String cropId) {
    return _apiClient
        .watch('/crops/$cropId/health')
        .map((response) {
          final List<dynamic> data = response.data['records'];
          return data.map((json) => CropHealth.fromJson(json)).toList();
        });
  }
} 