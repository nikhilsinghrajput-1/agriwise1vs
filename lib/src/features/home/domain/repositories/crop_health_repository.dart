import 'package:myapp/src/features/home/data/models/crop_health_model.dart';

abstract class CropHealthRepository {
  Future<CropHealthModel> getCropHealthData();
}
