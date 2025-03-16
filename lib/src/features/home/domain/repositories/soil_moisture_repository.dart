import 'package:myapp/src/features/home/data/models/soil_moisture_model.dart';

abstract class SoilMoistureRepository {
  Future<SoilMoistureModel> getSoilMoistureData();
}
