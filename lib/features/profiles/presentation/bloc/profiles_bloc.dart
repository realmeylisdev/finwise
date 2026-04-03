import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/features/profiles/domain/entities/profile_entity.dart';
import 'package:finwise/features/profiles/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

part 'profiles_event.dart';
part 'profiles_state.dart';

@injectable
class ProfilesBloc extends Bloc<ProfilesEvent, ProfilesState> {
  ProfilesBloc({required ProfileRepository repository})
      : _repository = repository,
        super(const ProfilesState()) {
    on<ProfilesLoaded>(_onLoaded, transformer: droppable());
    on<ProfileCreated>(_onCreated, transformer: droppable());
    on<ProfileUpdated>(_onUpdated, transformer: droppable());
    on<ProfileDeleted>(_onDeleted, transformer: droppable());
  }

  final ProfileRepository _repository;

  Future<void> _onLoaded(
    ProfilesLoaded event,
    Emitter<ProfilesState> emit,
  ) async {
    emit(state.copyWith(status: ProfilesStatus.loading));

    final result = await _repository.getProfiles();
    final ownerResult = await _repository.getOwnerProfile();

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProfilesStatus.failure,
        failureMessage: failure.message,
      )),
      (profiles) {
        final owner = ownerResult.getOrElse((_) => null);
        emit(state.copyWith(
          status: ProfilesStatus.success,
          profiles: profiles,
          currentProfile: owner,
        ));
      },
    );
  }

  Future<void> _onCreated(
    ProfileCreated event,
    Emitter<ProfilesState> emit,
  ) async {
    final result = await _repository.createProfile(event.profile);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ProfilesStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const ProfilesLoaded()),
    );
  }

  Future<void> _onUpdated(
    ProfileUpdated event,
    Emitter<ProfilesState> emit,
  ) async {
    final result = await _repository.updateProfile(event.profile);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ProfilesStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const ProfilesLoaded()),
    );
  }

  Future<void> _onDeleted(
    ProfileDeleted event,
    Emitter<ProfilesState> emit,
  ) async {
    final result = await _repository.deleteProfile(event.id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ProfilesStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const ProfilesLoaded()),
    );
  }
}
