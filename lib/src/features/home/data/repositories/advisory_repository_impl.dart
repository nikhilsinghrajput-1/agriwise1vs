import 'package:myapp/src/features/home/data/datasources/advisory_remote_data_source.dart';
import 'package:myapp/src/features/home/domain/repositories/advisory_repository.dart';

class AdvisoryRepositoryImpl implements AdvisoryRepository {
  final AdvisoryRemoteDataSource remoteDataSource;

  AdvisoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> getAdvisoryData() async {
    final advisoryModel = await remoteDataSource.getAdvisoryData();
    return {
      'description': advisoryModel.description,
    };
  }
}
