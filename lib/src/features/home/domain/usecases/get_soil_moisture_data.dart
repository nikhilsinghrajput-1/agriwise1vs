import 'package:myapp/src/features/home/data/models/soil_moisture_model.dart';
import 'package:myapp/src/features/home/domain/repositories/soil_moisture_repository.dart';

class GetSoilMoistureData {
  final SoilMoistureRepository repository;

  GetSoilMoistureData({required this.repository});

  Future<SoilMoistureModel> execute() async {
    return await repository.getSoilMoistureData();
  }
}
