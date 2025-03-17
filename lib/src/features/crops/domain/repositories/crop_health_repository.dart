import '../models/crop_health_model.dart';

abstract class CropHealthRepository {
  Future<List<CropHealth>> getCropHealthHistory(String cropId);
  Future<CropHealth> addCropHealthRecord(CropHealth record);
  Future<void> deleteCropHealthRecord(String recordId);
  Stream<List<CropHealth>> watchCropHealthHistory(String cropId);
} 