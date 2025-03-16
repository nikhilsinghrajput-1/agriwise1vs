import 'package:myapp/src/core/errors/exceptions.dart';
import 'package:myapp/src/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:myapp/src/features/profile/data/models/profile_model.dart';
import 'package:myapp/src/features/profile/domain/entities/profile.dart';
import 'package:myapp/src/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Profile> getProfile() async {
    try {
      final result = await remoteDataSource.getProfile();
      return ProfileModel.fromJson(result);
    } on ServerException {
      throw ServerException();
    }
  }

  @override
  Future<Profile> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final result = await remoteDataSource.updateProfile(profileData);
      return ProfileModel.fromJson(result);
    } on ServerException {
      throw ServerException();
    }
  }
}
