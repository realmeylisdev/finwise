part of 'net_worth_bloc.dart';

abstract class NetWorthEvent extends Equatable {
  const NetWorthEvent();
  @override
  List<Object?> get props => [];
}

class NetWorthLoaded extends NetWorthEvent {
  const NetWorthLoaded();
}

class AssetCreated extends NetWorthEvent {
  const AssetCreated(this.asset);
  final AssetEntity asset;
  @override
  List<Object?> get props => [asset];
}

class AssetUpdated extends NetWorthEvent {
  const AssetUpdated(this.asset);
  final AssetEntity asset;
  @override
  List<Object?> get props => [asset];
}

class AssetDeleted extends NetWorthEvent {
  const AssetDeleted(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}

class LiabilityCreated extends NetWorthEvent {
  const LiabilityCreated(this.liability);
  final LiabilityEntity liability;
  @override
  List<Object?> get props => [liability];
}

class LiabilityUpdated extends NetWorthEvent {
  const LiabilityUpdated(this.liability);
  final LiabilityEntity liability;
  @override
  List<Object?> get props => [liability];
}

class LiabilityDeleted extends NetWorthEvent {
  const LiabilityDeleted(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}

class SnapshotTaken extends NetWorthEvent {
  const SnapshotTaken();
}
