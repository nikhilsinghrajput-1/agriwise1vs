import 'package:myapp/src/features/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile();
  Future<Profile> updateProfile(Map<String, dynamic> profileData);
}
