part of 'profiles_bloc.dart';

abstract class ProfilesEvent extends Equatable {
  const ProfilesEvent();
  @override
  List<Object?> get props => [];
}

class ProfilesLoaded extends ProfilesEvent {
  const ProfilesLoaded();
}

class ProfileCreated extends ProfilesEvent {
  const ProfileCreated(this.profile);
  final ProfileEntity profile;
  @override
  List<Object?> get props => [profile];
}

class ProfileUpdated extends ProfilesEvent {
  const ProfileUpdated(this.profile);
  final ProfileEntity profile;
  @override
  List<Object?> get props => [profile];
}

class ProfileDeleted extends ProfilesEvent {
  const ProfileDeleted(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}
