import '../../../../core/services/firebase_service.dart';
import '../../domain/repositories/crop_repository.dart';
import '../../domain/entities/crop.dart';
import '../models/crop_model.dart';

class CropRepositoryImpl implements CropRepository {
  final FirebaseService _firebaseService;

  CropRepositoryImpl(this._firebaseService);

  @override
  Future<Crop> addCrop(Crop crop) async {
    final cropModel = CropModel.fromEntity(crop);
    await _firebaseService.addCrop(
      userId: cropModel.userId,
      name: cropModel.name,
      variety: cropModel.variety,
      plantingDate: cropModel.plantingDate,
      expectedHarvestDate: cropModel.expectedHarvestDate,
      status: cropModel.status,
    );
    return crop;
  }

  @override
  Stream<List<Crop>> getUserCrops(String userId) {
    return _firebaseService.getUserCrops(userId).map((cropsList) {
      return cropsList.map((cropMap) => CropModel.fromJson(cropMap).toEntity()).toList();
    });
  }

  @override
  Future<void> updateCrop(Crop crop) async {
    final cropModel = CropModel.fromEntity(crop);
    await _firebaseService.updateCrop(cropModel.id, cropModel.toJson());
  }

  @override
  Future<void> deleteCrop(String cropId) async {
    await _firebaseService.deleteCrop(cropId);
  }
} 