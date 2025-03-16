import 'package:myapp/src/features/home/domain/entities/advisory.dart';
import 'package:myapp/src/features/home/domain/repositories/home_repository.dart';

class GetAdvisories {
  final HomeRepository homeRepository;

  GetAdvisories({required this.homeRepository});

  Future<List<Advisory>> execute() async {
    return await homeRepository.getAdvisories();
  }
}
