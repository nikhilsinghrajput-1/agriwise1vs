import 'package:myapp/src/features/home/domain/entities/advisory.dart';

abstract class HomeRepository {
  Future<List<Advisory>> getAdvisories();
}
