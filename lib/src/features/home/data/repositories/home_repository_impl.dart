import 'package:myapp/src/core/errors/exceptions.dart';
import 'package:myapp/src/features/home/data/datasources/home_remote_data_source.dart';
import 'package:myapp/src/features/home/data/models/advisory_model.dart';
import 'package:myapp/src/features/home/domain/entities/advisory.dart';
import 'package:myapp/src/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Advisory>> getAdvisories() async {
    try {
      final result = await remoteDataSource.getAdvisories();
      return (result as List).map((e) => Advisory.fromModel(AdvisoryModel.fromJson(e))).toList();
    } on ServerException {
      throw const ServerException(message: 'Server error');
    }
  }
}
