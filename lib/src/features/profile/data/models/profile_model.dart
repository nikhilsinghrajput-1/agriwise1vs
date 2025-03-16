import 'package:myapp/src/features/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  ProfileModel({
    required super.id,
    required super.name,
    required super.bio,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
    };
  }
}
