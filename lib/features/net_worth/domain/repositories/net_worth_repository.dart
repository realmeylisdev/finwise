import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/net_worth/domain/entities/asset_entity.dart';
import 'package:finwise/features/net_worth/domain/entities/liability_entity.dart';
import 'package:finwise/features/net_worth/domain/entities/net_worth_snapshot_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class NetWorthRepository {
  Future<Either<Failure, List<AssetEntity>>> getAssets();
  Future<Either<Failure, AssetEntity>> createAsset(AssetEntity asset);
  Future<Either<Failure, AssetEntity>> updateAsset(AssetEntity asset);
  Future<Either<Failure, void>> deleteAsset(String id);

  Future<Either<Failure, List<LiabilityEntity>>> getLiabilities();
  Future<Either<Failure, LiabilityEntity>> createLiability(
    LiabilityEntity liability,
  );
  Future<Either<Failure, LiabilityEntity>> updateLiability(
    LiabilityEntity liability,
  );
  Future<Either<Failure, void>> deleteLiability(String id);

  Future<Either<Failure, List<NetWorthSnapshotEntity>>> getSnapshots();
  Future<Either<Failure, NetWorthSnapshotEntity>> takeSnapshot();
  Future<Either<Failure, double>> getCurrentNetWorth();
}
