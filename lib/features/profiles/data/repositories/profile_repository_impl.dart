import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/profiles/data/datasources/profile_local_datasource.dart';
import 'package:finwise/features/profiles/domain/entities/profile_entity.dart';
import 'package:finwise/features/profiles/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._datasource);

  final ProfileLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<ProfileEntity>>> getProfiles() async {
    try {
      final profiles = await _datasource.getAllProfiles();
      return Right(profiles);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity?>> getOwnerProfile() async {
    try {
      final owner = await _datasource.getOwnerProfile();
      return Right(owner);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> createProfile(
    ProfileEntity profile,
  ) async {
    try {
      await _datasource.insertProfile(profile);
      return Right(profile);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(
    ProfileEntity profile,
  ) async {
    try {
      await _datasource.updateProfile(profile);
      return Right(profile);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfile(String id) async {
    try {
      await _datasource.deleteProfile(id);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
