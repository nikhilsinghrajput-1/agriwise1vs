import 'package:myapp/src/features/home/data/datasources/crop_health_remote_data_source.dart';
import 'package:myapp/src/features/home/data/models/crop_health_model.dart';
import 'package:myapp/src/features/home/domain/repositories/crop_health_repository.dart';

class CropHealthRepositoryImpl implements CropHealthRepository {
  final CropHealthRemoteDataSource remoteDataSource;

  CropHealthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CropHealthModel> getCropHealthData() async {
    return await remoteDataSource.getCropHealthData();
  }
}
