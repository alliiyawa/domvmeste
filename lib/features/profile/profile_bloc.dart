import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/user_models.dart';
import '../../../data/repositories/user_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository repository;

  ProfileBloc(this.repository) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = await repository.getUser(event.userId);
        emit(ProfileLoaded(user));
      } catch (e) {
        emit(ProfileError());
      }
    });

    on<UpdateProfile>((event, emit) async {
      try {
        await repository.updateUser(event.user);
        emit(ProfileLoaded(event.user));
      } catch (e) {
        emit(ProfileError());
      }
    });
  }
}