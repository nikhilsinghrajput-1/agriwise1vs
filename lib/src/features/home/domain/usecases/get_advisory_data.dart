import 'package:myapp/src/core/repositories/base_repository.dart';
import 'package:myapp/src/features/home/domain/entities/advisory.dart';
import 'package:myapp/src/features/home/domain/repositories/advisory_repository.dart';

class GetAdvisoryData {
  final AdvisoryRepository repository;

  GetAdvisoryData({required this.repository});

  Future<Result<List<Advisory>>> execute() async {
    return await repository.getAdvisories();
  }
}
