import 'package:myapp/src/core/errors/exceptions.dart';
import 'package:myapp/src/core/network/connectivity_service.dart';
import 'package:myapp/src/core/repositories/base_repository.dart';
import 'package:myapp/src/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:myapp/src/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:myapp/src/features/authentication/domain/entities/user.dart';
import 'package:myapp/src/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final ConnectivityService connectivityService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivityService,
  });

 @override
Future<Result<User>> signIn(String email, String password) async {
    if (!await connectivityService.hasInternetConnection()) {
      return Result.failure(
        const NetworkException(message: 'No internet connection available'),
      );
    }

  try {
    final userModel = await remoteDataSource.signIn(email, password);
    await localDataSource.cacheUser(userModel);
    return Result.success(userModel.toEntity());
  } on ServerException catch (e) {
    return Result.failure(ServerException(message: e.message));
  } catch (e) {
    return Result.failure(ServerException(message: 'An unexpected error occurred'));
  }
}

@override
Future<Result<User>> signUp(String name, String email, String password, String phone) async {
    if (!await connectivityService.hasInternetConnection()) {
      return Result.failure(
        const NetworkException(message: 'No internet connection available'),
      );
    }

  try {
    final userModel = await remoteDataSource.signUp(name, email, password, phone);
    await localDataSource.cacheUser(userModel);
    return Result.success(userModel.toEntity());
  } on ServerException catch (e) {
    return Result.failure(ServerException(message: e.message));
  } catch (e) {
    return Result.failure(ServerException(message: 'An unexpected error occurred'));
  }
}


  
@override
Future<Result<bool>> signOut() async {
  try {
    await remoteDataSource.signOut();
    await localDataSource.clearUser();
    return Result.success(true);
  } catch (e) {
    return Result.failure(ServerException(message: 'Failed to sign out'));
  }
}


 @override
Future<Result<User?>> getCurrentUser() async {
  try {
    // First try to get from local cache
    final cachedUser = await localDataSource.getUser();
    if (cachedUser != null) {
      return Result.success(cachedUser.toEntity());
    }

    // If not in cache and we have internet, try to get from remote
    if (await connectivityService.hasInternetConnection()) {
      final remoteUser = await remoteDataSource.getCurrentUser();
      if (remoteUser != null) {
        await localDataSource.cacheUser(remoteUser);
        return Result.success(remoteUser.toEntity());
      }
    }

    // No user found
    return Result.success(null);
  } on CacheException catch (e) {
    return Result.failure(CacheException(message: e.message));
  } catch (e) {
    return Result.failure(ServerException(message: 'Failed to get current user'));
  }
}


  @override
Future<Result<bool>> resetPassword(String email) async {
  if (!await connectivityService.hasInternetConnection()) {
    return Result.failure(
      const NetworkException(message: 'No internet connection available'),
    );
  }

  try {
    await remoteDataSource.resetPassword(email);
    return Result.success(true);
  } on ServerException catch (e) {
    return Result.failure(ServerException(message: e.message));
  } catch (e) {
    return Result.failure(ServerException(message: 'Failed to reset password'));
  }
}
}
