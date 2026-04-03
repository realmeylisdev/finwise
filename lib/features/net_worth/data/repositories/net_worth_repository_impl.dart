import 'package:finwise/core/errors/failures.dart';
import 'package:finwise/features/net_worth/data/datasources/net_worth_local_datasource.dart';
import 'package:finwise/features/net_worth/domain/entities/asset_entity.dart';
import 'package:finwise/features/net_worth/domain/entities/liability_entity.dart';
import 'package:finwise/features/net_worth/domain/entities/net_worth_snapshot_entity.dart';
import 'package:finwise/features/net_worth/domain/repositories/net_worth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: NetWorthRepository)
class NetWorthRepositoryImpl implements NetWorthRepository {
  NetWorthRepositoryImpl(this._datasource);

  final NetWorthLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<AssetEntity>>> getAssets() async {
    try {
      final assets = await _datasource.getAssets();
      return Right(assets);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AssetEntity>> createAsset(AssetEntity asset) async {
    try {
      await _datasource.insertAsset(asset);
      return Right(asset);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AssetEntity>> updateAsset(AssetEntity asset) async {
    try {
      await _datasource.updateAsset(asset);
      return Right(asset);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAsset(String id) async {
    try {
      await _datasource.deleteAsset(id);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LiabilityEntity>>> getLiabilities() async {
    try {
      final liabilities = await _datasource.getLiabilities();
      return Right(liabilities);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LiabilityEntity>> createLiability(
    LiabilityEntity liability,
  ) async {
    try {
      await _datasource.insertLiability(liability);
      return Right(liability);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LiabilityEntity>> updateLiability(
    LiabilityEntity liability,
  ) async {
    try {
      await _datasource.updateLiability(liability);
      return Right(liability);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLiability(String id) async {
    try {
      await _datasource.deleteLiability(id);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NetWorthSnapshotEntity>>> getSnapshots() async {
    try {
      final snapshots = await _datasource.getSnapshots();
      return Right(snapshots);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, NetWorthSnapshotEntity>> takeSnapshot() async {
    try {
      final snapshot = await _datasource.takeSnapshot();
      return Right(snapshot);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getCurrentNetWorth() async {
    try {
      final netWorth = await _datasource.getCurrentNetWorth();
      return Right(netWorth);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
