import 'package:equatable/equatable.dart';

class NetWorthSnapshotEntity extends Equatable {
  const NetWorthSnapshotEntity({
    required this.id,
    required this.date,
    required this.totalAssets,
    required this.totalLiabilities,
    required this.netWorth,
  });

  final String id;
  final DateTime date;
  final double totalAssets;
  final double totalLiabilities;
  final double netWorth;

  @override
  List<Object?> get props => [id, date, totalAssets, totalLiabilities, netWorth];
}
