import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/onboarding_checklist/domain/entities/checklist_item_entity.dart';
import 'package:finwise/features/onboarding_checklist/presentation/bloc/checklist_bloc.dart';
import 'package:finwise/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:finwise/shared/widgets/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChecklistCard extends StatelessWidget {
  const ChecklistCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ChecklistBloc, ChecklistState>(
      builder: (context, state) {
        if (state.status != ChecklistStatus.success) {
          return const SizedBox.shrink();
        }

        if (state.isAllComplete) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.w, 8.w, 0),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF6366F1),
                              Color(0xFF818CF8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: AppIcon(
                          icon: HugeIcons.strokeRoundedCheckList,
                          color: Colors.white,
                          size: 18.w,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Getting Started',
                              style:
                                  theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              '${state.completedCount} of ${state.totalCount} complete',
                              style:
                                  theme.textTheme.bodySmall?.copyWith(
                                color:
                                    theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 18.w,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          context
                              .read<SettingsBloc>()
                              .add(const SettingsChecklistDismissed());
                        },
                      ),
                    ],
                  ),
                ),

                // Progress bar
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 4.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: state.totalCount > 0
                          ? state.completedCount / state.totalCount
                          : 0,
                      minHeight: 6.h,
                      backgroundColor:
                          AppColors.primary.withValues(alpha: 0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ),

                // Checklist items
                Padding(
                  padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 8.w),
                  child: Column(
                    children: state.items
                        .map((item) => _ChecklistItemTile(item: item))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ChecklistItemTile extends StatelessWidget {
  const _ChecklistItemTile({required this.item});

  final ChecklistItemEntity item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: item.isCompleted ? null : () => context.push(item.route),
      borderRadius: BorderRadius.circular(10.r),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 10.h,
        ),
        child: Row(
          children: [
            // Check icon
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.isCompleted
                    ? AppColors.income.withValues(alpha: 0.15)
                    : theme.colorScheme.outlineVariant
                        .withValues(alpha: 0.15),
                border: Border.all(
                  color: item.isCompleted
                      ? AppColors.income
                      : theme.colorScheme.outlineVariant
                          .withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: item.isCompleted
                  ? Icon(
                      Icons.check_rounded,
                      size: 16.w,
                      color: AppColors.income,
                    )
                  : null,
            ),
            SizedBox(width: 12.w),

            // Title & description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      decoration: item.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: item.isCompleted
                          ? theme.colorScheme.onSurfaceVariant
                          : null,
                    ),
                  ),
                  if (!item.isCompleted) ...[
                    SizedBox(height: 2.h),
                    Text(
                      item.description,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Arrow for incomplete items
            if (!item.isCompleted)
              Icon(
                Icons.chevron_right_rounded,
                size: 20.w,
                color: theme.colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}
