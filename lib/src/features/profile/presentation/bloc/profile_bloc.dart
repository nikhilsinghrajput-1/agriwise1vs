import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/src/features/profile/domain/entities/profile.dart';
import 'package:myapp/src/features/profile/domain/usecases/update_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateProfile updateProfile;
  ProfileBloc({required this.updateProfile}) : super(ProfileInitial()) {
    on<UpdateProfileRequested>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await updateProfile.execute(event.profileData);
        emit(ProfileSuccess(profile: profile));
      } catch (e) {
        emit(ProfileFailure(error: e.toString()));
      }
    });
  }
}
