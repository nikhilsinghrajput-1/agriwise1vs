import 'package:myapp/src/features/home/domain/repositories/advisory_repository.dart';

class GetAdvisoryData {
  final AdvisoryRepository repository;

  GetAdvisoryData({required this.repository});

  Future<Map<String, dynamic>> execute() async {
    return await repository.getAdvisoryData();
  }
}
