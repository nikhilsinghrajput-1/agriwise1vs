import 'package:myapp/src/core/errors/exceptions.dart';
import 'package:myapp/src/core/network/connectivity_service.dart';
import 'package:myapp/src/features/profile/domain/entities/profile.dart';
import 'package:myapp/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:myapp/src/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:myapp/src/features/profile/data/datasources/profile_local_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  final ConnectivityService connectivityService;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivityService,
  });

  @override
  Future<Profile> getProfile() async {
    if (!await connectivityService.hasInternetConnection()) {
      throw const NetworkException(message: 'No internet connection available');
    }
    try {
      final profileModel = await remoteDataSource.getProfile();
      // Note: We're assuming the local data source exists for caching
      // await localDataSource.cacheProfile(profileModel);
      return profileModel.toEntity();
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: "An unexpected error occurred");
    }
  }

  @override
  Future<Profile> updateProfile(Map<String, dynamic> profileData) async {
    if (!await connectivityService.hasInternetConnection()) {
      throw const NetworkException(message: 'No internet connection available');
    }
    try {
      final updatedProfile = await remoteDataSource.updateProfile(profileData);
      return updatedProfile.toEntity();
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'An unexpected error occurred');
    }
  }
}
