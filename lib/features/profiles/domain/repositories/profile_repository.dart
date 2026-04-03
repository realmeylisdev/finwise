import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/profiles/domain/entities/profile_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class ProfileRepository {
  Future<Either<Failure, List<ProfileEntity>>> getProfiles();
  Future<Either<Failure, ProfileEntity?>> getOwnerProfile();
  Future<Either<Failure, ProfileEntity>> createProfile(ProfileEntity profile);
  Future<Either<Failure, ProfileEntity>> updateProfile(ProfileEntity profile);
  Future<Either<Failure, void>> deleteProfile(String id);
}
