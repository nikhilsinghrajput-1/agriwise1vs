import 'package:myapp/src/core/repositories/base_repository.dart';
import 'package:myapp/src/features/home/domain/entities/advisory.dart';

abstract class AdvisoryRepository {
  Future<Result<List<Advisory>>> getAdvisories();
}
