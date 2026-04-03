import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/cash_flow/domain/entities/cash_flow_projection_entity.dart';
import 'package:finwise/features/cash_flow/presentation/bloc/cash_flow_bloc.dart';
import 'package:finwise/features/cash_flow/presentation/widgets/cash_flow_chart.dart';
import 'package:finwise/shared/widgets/skeleton_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CashFlowPage extends StatefulWidget {
  const CashFlowPage({super.key});

  @override
  State<CashFlowPage> createState() => _CashFlowPageState();
}

class _CashFlowPageState extends State<CashFlowPage> {
  @override
  void initState() {
    super.initState();
    context.read<CashFlowBloc>().add(const CashFlowLoaded());
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cash Flow Forecast'),
      ),
      body: BlocBuilder<CashFlowBloc, CashFlowState>(
        builder: (context, state) {
          if (state.status == CashFlowStatus.loading ||
              state.status == CashFlowStatus.initial) {
            return Padding(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              child: const SkeletonListTileGroup(count: 6),
            );
          }

          if (state.status == CashFlowStatus.failure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.paddingL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48.w,
                      color: AppColors.expense,
                    ),
                    SizedBox(height: AppDimensions.paddingM),
                    Text(
                      state.failureMessage ?? 'Failed to generate forecast',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: AppDimensions.paddingM),
                    FilledButton.icon(
                      onPressed: () => context
                          .read<CashFlowBloc>()
                          .add(const CashFlowLoaded()),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final projection = state.projection;
          if (projection == null) {
            return const Center(child: Text('No data available'));
          }

          return ListView(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            children: [
              // Summary cards row
              _SummaryCardsRow(
                startBalance: projection.startBalance,
                lowestBalance: projection.lowestBalance,
                endBalance: projection.endBalance,
                currencyFormat: currencyFormat,
              ),
              SizedBox(height: AppDimensions.paddingL),

              // Chart
              Text(
                '30-Day Projection',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: AppDimensions.paddingS),
              CashFlowChart(projections: projection.projections),
              SizedBox(height: AppDimensions.paddingL),

              // Lowest point warning
              if (projection.lowestBalance < 0)
                Padding(
                  padding:
                      EdgeInsets.only(bottom: AppDimensions.paddingM),
                  child: Card(
                    color: AppColors.expenseBg,
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.paddingM),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.expense,
                            size: 24.w,
                          ),
                          SizedBox(width: AppDimensions.paddingS),
                          Expanded(
                            child: Text(
                              'Balance projected to go negative on '
                              '${DateFormat('MMM d').format(projection.lowestBalanceDate)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.expense),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Forecast Details
              Text(
                'Forecast Details',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: AppDimensions.paddingS),
              ...projection.projections.map(
                (day) => _DailyProjectionTile(
                  projection: day,
                  currencyFormat: currencyFormat,
                ),
              ),
              SizedBox(height: AppDimensions.paddingXL),
            ],
          );
        },
      ),
    );
  }
}

// ── Summary Cards Row ──

class _SummaryCardsRow extends StatelessWidget {
  const _SummaryCardsRow({
    required this.startBalance,
    required this.lowestBalance,
    required this.endBalance,
    required this.currencyFormat,
  });

  final double startBalance;
  final double lowestBalance;
  final double endBalance;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Starting',
            value: currencyFormat.format(startBalance),
            color: AppColors.primary,
          ),
        ),
        SizedBox(width: AppDimensions.paddingS),
        Expanded(
          child: _SummaryCard(
            label: 'Lowest',
            value: currencyFormat.format(lowestBalance),
            color: lowestBalance < 0 ? AppColors.expense : AppColors.budgetWarning,
          ),
        ),
        SizedBox(width: AppDimensions.paddingS),
        Expanded(
          child: _SummaryCard(
            label: 'End',
            value: currencyFormat.format(endBalance),
            color: endBalance >= startBalance
                ? AppColors.income
                : AppColors.expense,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingS,
          vertical: AppDimensions.paddingM,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: 4.h),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Daily Projection Tile ──

class _DailyProjectionTile extends StatelessWidget {
  const _DailyProjectionTile({
    required this.projection,
    required this.currencyFormat,
  });

  final DailyProjection projection;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    final isNegative = projection.projectedBalance < 0;
    final dateFormat = DateFormat('EEE, MMM d');

    return Card(
      color: isNegative
          ? AppColors.expenseBg.withValues(alpha: 0.5)
          : null,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        child: Row(
          children: [
            // Date
            SizedBox(
              width: 90.w,
              child: Text(
                dateFormat.format(projection.date),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            // Incoming
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (projection.incoming > 0)
                    Text(
                      '+${currencyFormat.format(projection.incoming)}',
                      style: TextStyle(
                        color: AppColors.income,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (projection.outgoing > 0)
                    Text(
                      '-${currencyFormat.format(projection.outgoing)}',
                      style: TextStyle(
                        color: AppColors.expense,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: AppDimensions.paddingM),
            // Balance
            SizedBox(
              width: 85.w,
              child: Text(
                currencyFormat.format(projection.projectedBalance),
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: isNegative ? AppColors.expense : null,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
