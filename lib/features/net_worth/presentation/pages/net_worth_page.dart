import 'package:finwise/core/navigation/app_routes.dart';
import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/net_worth/domain/entities/asset_entity.dart';
import 'package:finwise/features/net_worth/domain/entities/liability_entity.dart';
import 'package:finwise/features/net_worth/presentation/bloc/net_worth_bloc.dart';
import 'package:finwise/features/net_worth/presentation/widgets/net_worth_chart.dart';
import 'package:finwise/shared/widgets/privacy_amount.dart';
import 'package:finwise/shared/widgets/skeleton_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class NetWorthPage extends StatefulWidget {
  const NetWorthPage({super.key});

  @override
  State<NetWorthPage> createState() => _NetWorthPageState();
}

class _NetWorthPageState extends State<NetWorthPage> {
  @override
  void initState() {
    super.initState();
    context.read<NetWorthBloc>().add(const NetWorthLoaded());
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Net Worth'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            tooltip: 'Take Snapshot',
            onPressed: () {
              context.read<NetWorthBloc>().add(const SnapshotTaken());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Snapshot recorded')),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NetWorthBloc, NetWorthState>(
        builder: (context, state) {
          if (state.status == NetWorthStatus.loading) {
            return Padding(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              child: const SkeletonListTileGroup(count: 5),
            );
          }

          return ListView(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            children: [
              // Net Worth Header
              _NetWorthHeader(
                netWorth: state.netWorth,
                totalAssets: state.totalAssets,
                totalLiabilities: state.totalLiabilities,
                currencyFormat: currencyFormat,
              ),
              SizedBox(height: AppDimensions.paddingL),

              // Chart
              Text(
                'Net Worth History',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: AppDimensions.paddingS),
              NetWorthChart(snapshots: state.snapshots),
              SizedBox(height: AppDimensions.paddingL),

              // Assets Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Assets',
                    style:
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                  ),
                  TextButton.icon(
                    onPressed: () =>
                        context.push(AppRoutes.netWorthAssetForm),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                  ),
                ],
              ),
              if (state.assets.isEmpty)
                _EmptySection(
                  message: 'No assets added yet',
                  onAdd: () =>
                      context.push(AppRoutes.netWorthAssetForm),
                )
              else
                ...state.assets.map(
                  (asset) => _AssetTile(
                    asset: asset,
                    currencyFormat: currencyFormat,
                    onEdit: () => context.push(
                      AppRoutes.netWorthAssetForm,
                      extra: asset,
                    ),
                    onDelete: () => _confirmDeleteAsset(context, asset),
                  ),
                ),
              SizedBox(height: AppDimensions.paddingL),

              // Liabilities Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Liabilities',
                    style:
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                  ),
                  TextButton.icon(
                    onPressed: () =>
                        context.push(AppRoutes.netWorthLiabilityForm),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                  ),
                ],
              ),
              if (state.liabilities.isEmpty)
                _EmptySection(
                  message: 'No liabilities added yet',
                  onAdd: () =>
                      context.push(AppRoutes.netWorthLiabilityForm),
                )
              else
                ...state.liabilities.map(
                  (liability) => _LiabilityTile(
                    liability: liability,
                    currencyFormat: currencyFormat,
                    onEdit: () => context.push(
                      AppRoutes.netWorthLiabilityForm,
                      extra: liability,
                    ),
                    onDelete: () =>
                        _confirmDeleteLiability(context, liability),
                  ),
                ),
              SizedBox(height: AppDimensions.paddingXL),
            ],
          );
        },
      ),
    );
  }

  void _confirmDeleteAsset(BuildContext context, AssetEntity asset) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Asset'),
        content: Text('Delete "${asset.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<NetWorthBloc>().add(AssetDeleted(asset.id));
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.expense),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteLiability(
    BuildContext context,
    LiabilityEntity liability,
  ) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Liability'),
        content: Text('Delete "${liability.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<NetWorthBloc>()
                  .add(LiabilityDeleted(liability.id));
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.expense),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ── Net Worth Header ──

class _NetWorthHeader extends StatelessWidget {
  const _NetWorthHeader({
    required this.netWorth,
    required this.totalAssets,
    required this.totalLiabilities,
    required this.currencyFormat,
  });

  final double netWorth;
  final double totalAssets;
  final double totalLiabilities;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary,
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          children: [
            Text(
              'Net Worth',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 4.h),
            PrivacyAmount(
              child: Text(
                currencyFormat.format(netWorth),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: AppDimensions.paddingM),
            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    label: 'Total Assets',
                    value: currencyFormat.format(totalAssets),
                    valueColor: AppColors.income,
                  ),
                ),
                Container(
                  width: 1,
                  height: 36.h,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: _SummaryItem(
                    label: 'Total Liabilities',
                    value: currencyFormat.format(totalLiabilities),
                    valueColor: AppColors.expense,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 11.sp,
          ),
        ),
        SizedBox(height: 2.h),
        PrivacyAmount(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Asset Tile ──

class _AssetTile extends StatelessWidget {
  const _AssetTile({
    required this.asset,
    required this.currencyFormat,
    required this.onEdit,
    required this.onDelete,
  });

  final AssetEntity asset;
  final NumberFormat currencyFormat;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  IconData get _icon {
    switch (asset.type) {
      case AssetType.property:
        return Icons.home_outlined;
      case AssetType.vehicle:
        return Icons.directions_car_outlined;
      case AssetType.crypto:
        return Icons.currency_bitcoin;
      case AssetType.stock:
        return Icons.show_chart;
      case AssetType.other:
        return Icons.account_balance_wallet_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.income.withValues(alpha: 0.1),
          child: Icon(_icon, color: AppColors.income, size: 20.w),
        ),
        title: Text(asset.name),
        subtitle: Text(AssetEntity.typeDisplayName(asset.type)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrivacyAmount(
              child: Text(
                currencyFormat.format(asset.value),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: AppColors.income,
                ),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Liability Tile ──

class _LiabilityTile extends StatelessWidget {
  const _LiabilityTile({
    required this.liability,
    required this.currencyFormat,
    required this.onEdit,
    required this.onDelete,
  });

  final LiabilityEntity liability;
  final NumberFormat currencyFormat;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  IconData get _icon {
    switch (liability.type) {
      case LiabilityType.mortgage:
        return Icons.house_outlined;
      case LiabilityType.carLoan:
        return Icons.directions_car_outlined;
      case LiabilityType.studentLoan:
        return Icons.school_outlined;
      case LiabilityType.creditCard:
        return Icons.credit_card;
      case LiabilityType.personalLoan:
        return Icons.person_outline;
      case LiabilityType.other:
        return Icons.receipt_long_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.expense.withValues(alpha: 0.1),
          child: Icon(_icon, color: AppColors.expense, size: 20.w),
        ),
        title: Text(liability.name),
        subtitle: Text(
          '${LiabilityEntity.typeDisplayName(liability.type)}'
          '${liability.interestRate > 0 ? ' \u00b7 ${liability.interestRate}%' : ''}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrivacyAmount(
              child: Text(
                currencyFormat.format(liability.balance),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: AppColors.expense,
                ),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty Section ──

class _EmptySection extends StatelessWidget {
  const _EmptySection({required this.message, required this.onAdd});

  final String message;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onAdd,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppDimensions.paddingL,
            horizontal: AppDimensions.paddingM,
          ),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: AppColors.disabled,
                  size: 32.w,
                ),
                SizedBox(height: AppDimensions.paddingS),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.disabled,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
