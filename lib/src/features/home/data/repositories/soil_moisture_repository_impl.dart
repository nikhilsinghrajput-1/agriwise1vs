import 'package:myapp/src/features/home/data/datasources/soil_moisture_remote_data_source.dart';
import 'package:myapp/src/features/home/data/models/soil_moisture_model.dart';
import 'package:myapp/src/features/home/domain/repositories/soil_moisture_repository.dart';

class SoilMoistureRepositoryImpl implements SoilMoistureRepository {
  final SoilMoistureRemoteDataSource remoteDataSource;

  SoilMoistureRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SoilMoistureModel> getSoilMoistureData() async {
    return await remoteDataSource.getSoilMoistureData();
  }
}
