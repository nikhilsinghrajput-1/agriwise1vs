part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class UpdateProfileRequested extends ProfileEvent {
  final Map<String, dynamic> profileData;

  UpdateProfileRequested({required this.profileData});
}
