import 'package:myapp/src/core/errors/exceptions.dart';
import 'package:myapp/src/features/profile/data/models/profile_model.dart';

abstract class ProfileLocalDataSource {
  /// Gets the cached [ProfileModel] which was gotten last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<ProfileModel> getCachedProfile();

  Future<void> cacheProfile(ProfileModel profileToCache);

  /// Clear user profile from cache
  Future<void> clearProfile();
}
