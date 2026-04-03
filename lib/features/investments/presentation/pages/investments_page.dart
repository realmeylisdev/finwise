import 'package:finwise/core/navigation/app_routes.dart';
import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/investments/domain/entities/investment_entity.dart';
import 'package:finwise/features/investments/presentation/bloc/investments_bloc.dart';
import 'package:finwise/features/investments/presentation/widgets/allocation_chart.dart';
import 'package:finwise/features/investments/presentation/widgets/portfolio_summary_card.dart';
import 'package:finwise/shared/widgets/skeleton_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class InvestmentsPage extends StatefulWidget {
  const InvestmentsPage({super.key});

  @override
  State<InvestmentsPage> createState() => _InvestmentsPageState();
}

class _InvestmentsPageState extends State<InvestmentsPage> {
  @override
  void initState() {
    super.initState();
    context.read<InvestmentsBloc>().add(const InvestmentsLoaded());
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(title: const Text('Investments')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.investmentForm),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<InvestmentsBloc, InvestmentsState>(
        builder: (context, state) {
          if (state.status == InvestmentsStatus.loading) {
            return Padding(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              child: const SkeletonListTileGroup(count: 5),
            );
          }

          return ListView(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            children: [
              // Portfolio Summary
              PortfolioSummaryCard(
                totalValue: state.performance?.totalValue ?? 0,
                gainLoss: state.performance?.totalGainLoss ?? 0,
                gainLossPercent:
                    state.performance?.totalGainLossPercent ?? 0,
              ),
              SizedBox(height: AppDimensions.paddingL),

              // Allocation Chart
              Text(
                'Asset Allocation',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: AppDimensions.paddingS),
              AllocationChart(
                allocationByType:
                    state.performance?.allocationByType ?? {},
              ),
              SizedBox(height: AppDimensions.paddingL),

              // Holdings List
              Text(
                'Holdings',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: AppDimensions.paddingS),

              if (state.investments.isEmpty)
                _EmptyHoldings(
                  onAdd: () => context.push(AppRoutes.investmentForm),
                )
              else
                ...state.investments.map(
                  (investment) => _InvestmentTile(
                    investment: investment,
                    currencyFormat: currencyFormat,
                    onTap: () => context.push(
                      AppRoutes.investmentForm,
                      extra: investment,
                    ),
                    onDelete: () =>
                        _confirmDelete(context, investment),
                  ),
                ),
              SizedBox(height: AppDimensions.paddingXL),
            ],
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, InvestmentEntity investment) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Investment'),
        content: Text('Delete "${investment.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<InvestmentsBloc>()
                  .add(InvestmentDeleted(investment.id));
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

// ── Investment Tile ──

class _InvestmentTile extends StatelessWidget {
  const _InvestmentTile({
    required this.investment,
    required this.currencyFormat,
    required this.onTap,
    required this.onDelete,
  });

  final InvestmentEntity investment;
  final NumberFormat currencyFormat;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  IconData get _icon {
    switch (investment.type) {
      case InvestmentType.stock:
        return Icons.show_chart;
      case InvestmentType.etf:
        return Icons.stacked_line_chart;
      case InvestmentType.mutualFund:
        return Icons.pie_chart_outline;
      case InvestmentType.crypto:
        return Icons.currency_bitcoin;
      case InvestmentType.bond:
        return Icons.account_balance_outlined;
      case InvestmentType.other:
        return Icons.account_balance_wallet_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = investment.gainLoss >= 0;
    final gainColor = isPositive ? AppColors.income : AppColors.expense;
    final gainSign = isPositive ? '+' : '';

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingS,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Icon(_icon, color: AppColors.primary, size: 20.w),
              ),
              SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      investment.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      [
                        if (investment.ticker != null) investment.ticker!,
                        '${investment.units} units',
                        '@${currencyFormat.format(investment.currentPrice)}',
                      ].join(' \u00b7 '),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.disabled,
                          ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currencyFormat.format(investment.currentValue),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '$gainSign${currencyFormat.format(investment.gainLoss)}'
                    ' ($gainSign${investment.gainLossPercent.toStringAsFixed(1)}%)',
                    style: TextStyle(
                      color: gainColor,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') onTap();
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
      ),
    );
  }
}

// ── Empty Holdings ──

class _EmptyHoldings extends StatelessWidget {
  const _EmptyHoldings({required this.onAdd});

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
                  'No investments yet',
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
