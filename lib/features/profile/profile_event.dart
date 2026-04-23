import 'package:dom_vmeste/data/models/user_models.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {
  final String userId;
  LoadProfile(this.userId);
}

class UpdateProfile extends ProfileEvent{
  final UserModel user;
  UpdateProfile(this.user);
}
