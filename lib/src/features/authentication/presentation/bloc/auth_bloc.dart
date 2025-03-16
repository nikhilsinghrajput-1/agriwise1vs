import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/src/features/authentication/domain/entities/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<GoogleSignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final User firebaseUser = userCredential.user!;

        if (firebaseUser != null) {
          // Store user data in Firestore
          await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).set({
            'uid': firebaseUser.uid,
            'email': firebaseUser.email,
            'displayName': firebaseUser.displayName,
            // Add other user details here, such as location and crop type
          }, SetOptions(merge: true));

          final UserProfile userProfile = UserProfile(id: firebaseUser.uid, username: firebaseUser.displayName ?? '', email: firebaseUser.email ?? '');

          emit(AuthSuccess(user: userProfile));
        } else {
          emit(AuthFailure(error: 'Google Sign-In failed'));
        }
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
        emit(AuthInitial());
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });
  }
}
