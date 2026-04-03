part of 'net_worth_bloc.dart';

enum NetWorthStatus { initial, loading, success, failure }

class NetWorthState extends Equatable {
  const NetWorthState({
    this.status = NetWorthStatus.initial,
    this.assets = const [],
    this.liabilities = const [],
    this.snapshots = const [],
    this.totalAssets = 0,
    this.totalLiabilities = 0,
    this.netWorth = 0,
    this.failureMessage,
  });

  final NetWorthStatus status;
  final List<AssetEntity> assets;
  final List<LiabilityEntity> liabilities;
  final List<NetWorthSnapshotEntity> snapshots;
  final double totalAssets;
  final double totalLiabilities;
  final double netWorth;
  final String? failureMessage;

  NetWorthState copyWith({
    NetWorthStatus? status,
    List<AssetEntity>? assets,
    List<LiabilityEntity>? liabilities,
    List<NetWorthSnapshotEntity>? snapshots,
    double? totalAssets,
    double? totalLiabilities,
    double? netWorth,
    String? failureMessage,
  }) {
    return NetWorthState(
      status: status ?? this.status,
      assets: assets ?? this.assets,
      liabilities: liabilities ?? this.liabilities,
      snapshots: snapshots ?? this.snapshots,
      totalAssets: totalAssets ?? this.totalAssets,
      totalLiabilities: totalLiabilities ?? this.totalLiabilities,
      netWorth: netWorth ?? this.netWorth,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [
        status, assets, liabilities, snapshots,
        totalAssets, totalLiabilities, netWorth, failureMessage,
      ];
}
