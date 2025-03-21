import '../entities/crop.dart';

abstract class CropRepository {
  Future<Crop> addCrop(Crop crop);
  Stream<List<Crop>> getUserCrops(String userId);
  Future<void> updateCrop(Crop crop);
  Future<void> deleteCrop(String cropId);
}
