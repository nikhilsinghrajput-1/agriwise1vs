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
    if (!await connectivityService.isConnected()) {
      return Result.failure(
        AppError(
          type: ErrorType.network,
          message: 'इंटरनेट कनेक्शन उपलब्ध नहीं है',
        ),
      );
    }

    try {
      final advisories = await remoteDataSource.getAdvisories();
      return Result.success(advisories);
    } on ServerException catch (e) {
      return Result.failure(
        AppError(
          type: ErrorType.server,
          message: e.message,
        ),
      );
    } on CacheException catch (e) {
      return Result.failure(
        AppError(
          type: ErrorType.cache,
          message: e.message,
        ),
      );
    } catch (e) {
      return Result.failure(
        AppError(
          type: ErrorType.unknown,
          message: 'एक अनपेक्षित त्रुटि हुई है',
        ),
      );
    }
  }
}
