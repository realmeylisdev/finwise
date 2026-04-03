part of 'profiles_bloc.dart';

enum ProfilesStatus { initial, loading, success, failure }

class ProfilesState extends Equatable {
  const ProfilesState({
    this.status = ProfilesStatus.initial,
    this.profiles = const [],
    this.currentProfile,
    this.failureMessage,
  });

  final ProfilesStatus status;
  final List<ProfileEntity> profiles;
  final ProfileEntity? currentProfile;
  final String? failureMessage;

  ProfilesState copyWith({
    ProfilesStatus? status,
    List<ProfileEntity>? profiles,
    ProfileEntity? currentProfile,
    String? failureMessage,
  }) {
    return ProfilesState(
      status: status ?? this.status,
      profiles: profiles ?? this.profiles,
      currentProfile: currentProfile ?? this.currentProfile,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [status, profiles, currentProfile, failureMessage];
}
