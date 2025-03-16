import 'package:myapp/src/features/home/data/models/crop_health_model.dart';
import 'package:myapp/src/features/home/domain/repositories/crop_health_repository.dart';

class GetCropHealthData {
  final CropHealthRepository repository;

  GetCropHealthData({required this.repository});

  Future<CropHealthModel> execute() async {
    return await repository.getCropHealthData();
  }
}
