import 'package:myapp/src/features/authentication/domain/entities/user.dart';

class UserModel {
  final String id;
  final String username;
  final String email;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['uid'],
      username: json['displayName'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }

  UserProfile toEntity() {
    return UserProfile(id: id, username: username, email: email);
  }
}
