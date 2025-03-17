import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/src/core/errors/exceptions.dart';
import 'package:myapp/src/features/authentication/data/models/user_model.dart';

class AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String USER_KEY = 'CACHED_USER';

  AuthLocalDataSource({required this.sharedPreferences});

  Future<void> cacheUser(UserModel user) async {
    try {
      await sharedPreferences.setString(
        USER_KEY,
        json.encode(user.toJson()),
      );
    } catch (e) {
      throw CacheException(message: 'Failed to cache user data');
    }
  }

  Future<UserModel?> getUser() async {
    try {
      final jsonString = sharedPreferences.getString(USER_KEY);
      if (jsonString == null) {
        return null;
      }
      return UserModel.fromJson(json.decode(jsonString));
    } catch (e) {
      throw CacheException(message: 'Failed to retrieve user data');
    }
  }

  Future<void> clearUser() async {
    try {
      await sharedPreferences.remove(USER_KEY);
    } catch (e) {
      throw CacheException(message: 'Failed to clear user data');
    }
  }
} 