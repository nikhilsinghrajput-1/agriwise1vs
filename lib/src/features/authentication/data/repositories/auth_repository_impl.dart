import 'package:myapp/src/core/errors/exceptions.dart';
import 'package:myapp/src/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:myapp/src/features/authentication/data/models/user_model.dart';
import 'package:myapp/src/features/authentication/domain/entities/user.dart';
import 'package:myapp/src/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserProfile> login(String username, String password) async {
    try {
      final result = await remoteDataSource.login(username, password);
      return UserModel.fromJson(result).toEntity();
    } on ServerException {
      throw ServerException();
    }
  }

  @override
  Future<UserProfile> signup(String username, String password, String email) async {
    try {
      final result = await remoteDataSource.signup(username, password, email);
      return UserModel.fromJson(result).toEntity();
    } on ServerException {
      throw ServerException();
    }
  }
}
