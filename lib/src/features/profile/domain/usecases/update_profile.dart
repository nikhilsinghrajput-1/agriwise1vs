import 'package:myapp/src/features/profile/domain/entities/profile.dart';
import 'package:myapp/src/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository profileRepository;

  UpdateProfile({required this.profileRepository});

  Future<Profile> execute(Map<String, dynamic> profileData) async {
    return await profileRepository.updateProfile(profileData);
  }
}
