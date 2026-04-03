import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/features/net_worth/domain/entities/asset_entity.dart';
import 'package:finwise/features/net_worth/domain/entities/liability_entity.dart';
import 'package:finwise/features/net_worth/domain/entities/net_worth_snapshot_entity.dart';
import 'package:finwise/features/net_worth/domain/repositories/net_worth_repository.dart';
import 'package:injectable/injectable.dart';

part 'net_worth_event.dart';
part 'net_worth_state.dart';

@injectable
class NetWorthBloc extends Bloc<NetWorthEvent, NetWorthState> {
  NetWorthBloc({required NetWorthRepository repository})
      : _repository = repository,
        super(const NetWorthState()) {
    on<NetWorthLoaded>(_onLoaded, transformer: droppable());
    on<AssetCreated>(_onAssetCreated, transformer: droppable());
    on<AssetUpdated>(_onAssetUpdated, transformer: droppable());
    on<AssetDeleted>(_onAssetDeleted, transformer: droppable());
    on<LiabilityCreated>(_onLiabilityCreated, transformer: droppable());
    on<LiabilityUpdated>(_onLiabilityUpdated, transformer: droppable());
    on<LiabilityDeleted>(_onLiabilityDeleted, transformer: droppable());
    on<SnapshotTaken>(_onSnapshotTaken, transformer: droppable());
  }

  final NetWorthRepository _repository;

  Future<void> _onLoaded(
    NetWorthLoaded event,
    Emitter<NetWorthState> emit,
  ) async {
    emit(state.copyWith(status: NetWorthStatus.loading));

    final assetsResult = await _repository.getAssets();
    final liabilitiesResult = await _repository.getLiabilities();
    final snapshotsResult = await _repository.getSnapshots();
    final netWorthResult = await _repository.getCurrentNetWorth();

    // Check for failures
    if (assetsResult.isLeft()) {
      emit(state.copyWith(
        status: NetWorthStatus.failure,
        failureMessage: assetsResult.getLeft().toNullable()?.message,
      ));
      return;
    }

    final assets = assetsResult.getOrElse((_) => []);
    final liabilities = liabilitiesResult.getOrElse((_) => []);
    final snapshots = snapshotsResult.getOrElse((_) => []);
    final totalAssets =
        assets.fold<double>(0, (sum, a) => sum + a.value);
    final totalLiabilities =
        liabilities.fold<double>(0, (sum, l) => sum + l.balance);
    final netWorth = netWorthResult.getOrElse((_) => 0);

    emit(state.copyWith(
      status: NetWorthStatus.success,
      assets: assets,
      liabilities: liabilities,
      snapshots: snapshots,
      totalAssets: totalAssets,
      totalLiabilities: totalLiabilities,
      netWorth: netWorth,
    ));
  }

  Future<void> _onAssetCreated(
    AssetCreated event,
    Emitter<NetWorthState> emit,
  ) async {
    final result = await _repository.createAsset(event.asset);
    result.fold(
      (failure) => emit(state.copyWith(
        status: NetWorthStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const NetWorthLoaded()),
    );
  }

  Future<void> _onAssetUpdated(
    AssetUpdated event,
    Emitter<NetWorthState> emit,
  ) async {
    final result = await _repository.updateAsset(event.asset);
    result.fold(
      (failure) => emit(state.copyWith(
        status: NetWorthStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const NetWorthLoaded()),
    );
  }

  Future<void> _onAssetDeleted(
    AssetDeleted event,
    Emitter<NetWorthState> emit,
  ) async {
    final result = await _repository.deleteAsset(event.id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: NetWorthStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const NetWorthLoaded()),
    );
  }

  Future<void> _onLiabilityCreated(
    LiabilityCreated event,
    Emitter<NetWorthState> emit,
  ) async {
    final result = await _repository.createLiability(event.liability);
    result.fold(
      (failure) => emit(state.copyWith(
        status: NetWorthStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const NetWorthLoaded()),
    );
  }

  Future<void> _onLiabilityUpdated(
    LiabilityUpdated event,
    Emitter<NetWorthState> emit,
  ) async {
    final result = await _repository.updateLiability(event.liability);
    result.fold(
      (failure) => emit(state.copyWith(
        status: NetWorthStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const NetWorthLoaded()),
    );
  }

  Future<void> _onLiabilityDeleted(
    LiabilityDeleted event,
    Emitter<NetWorthState> emit,
  ) async {
    final result = await _repository.deleteLiability(event.id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: NetWorthStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const NetWorthLoaded()),
    );
  }

  Future<void> _onSnapshotTaken(
    SnapshotTaken event,
    Emitter<NetWorthState> emit,
  ) async {
    final result = await _repository.takeSnapshot();
    result.fold(
      (failure) => emit(state.copyWith(
        status: NetWorthStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const NetWorthLoaded()),
    );
  }
}
