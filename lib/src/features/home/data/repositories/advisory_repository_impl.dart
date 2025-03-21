import 'package:myapp/src/core/errors/exceptions.dart';
import 'package:myapp/src/core/network/connectivity_service.dart';
import 'package:myapp/src/core/repositories/base_repository.dart';
import 'package:myapp/src/features/home/data/datasources/advisory_remote_data_source.dart';
import 'package:myapp/src/features/home/domain/entities/advisory.dart';
import 'package:myapp/src/features/home/domain/repositories/advisory_repository.dart';

class AdvisoryRepositoryImpl implements AdvisoryRepository {
  final AdvisoryRemoteDataSource remoteDataSource;
  final ConnectivityService connectivityService;

  AdvisoryRepositoryImpl({
    required this.remoteDataSource,
    required this.connectivityService,
  });

  @override
  Future<Result<List<Advisory>>> getAdvisories() async {
    if (!await connectivityService.hasInternetConnection()) {
      return Result.failure(
        ServerException(
          message: 'No internet connection available',
        ),
      );
    }

    try {
      final advisories = await remoteDataSource.getAdvisories();
      return Result.success(advisories);
    } on ServerException catch (e) {
      return Result.failure(
        ServerException(
          message: e.message,
        ),
      );
    } on CacheException catch (e) {
      return Result.failure(
        CacheException(
          message: e.message,
        ),
      );
    } catch (e) {
      return Result.failure(
        ServerException(
          message: 'An unexpected error occurred',
        ),
      );
    }
  }
}
