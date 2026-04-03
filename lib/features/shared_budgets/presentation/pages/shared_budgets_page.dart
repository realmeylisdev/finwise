import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/budget/domain/entities/budget_entity.dart';
import 'package:finwise/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:finwise/features/profiles/domain/entities/profile_entity.dart';
import 'package:finwise/features/profiles/presentation/bloc/profiles_bloc.dart';
import 'package:finwise/features/shared_budgets/domain/entities/shared_budget_entity.dart';
import 'package:finwise/features/shared_budgets/presentation/bloc/shared_budgets_bloc.dart';
import 'package:finwise/shared/widgets/skeleton_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

class SharedBudgetsPage extends StatefulWidget {
  const SharedBudgetsPage({super.key});

  @override
  State<SharedBudgetsPage> createState() => _SharedBudgetsPageState();
}

class _SharedBudgetsPageState extends State<SharedBudgetsPage> {
  String? _selectedBudgetId;

  @override
  void initState() {
    super.initState();
    context.read<ProfilesBloc>().add(const ProfilesLoaded());
  }

  void _selectBudget(String budgetId) {
    setState(() => _selectedBudgetId = budgetId);
    context.read<SharedBudgetsBloc>().add(SharedBudgetsLoaded(budgetId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shared Budgets')),
      body: BlocBuilder<BudgetBloc, BudgetState>(
        builder: (context, budgetState) {
          if (budgetState.status == BudgetStatus.loading) {
            return const SkeletonListTileGroup(count: 4);
          }

          final budgets = budgetState.budgets;

          if (budgets.isEmpty) {
            return _EmptyBudgets();
          }

          return ListView(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            children: [
              // Budget selector
              Text(
                'Select a budget to manage sharing',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              SizedBox(height: AppDimensions.paddingS),
              _BudgetSelector(
                budgets: budgets,
                selectedId: _selectedBudgetId,
                onSelected: _selectBudget,
              ),
              SizedBox(height: AppDimensions.paddingL),

              // Sharing controls
              if (_selectedBudgetId != null) ...[
                Text(
                  'Share with family members',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: AppDimensions.paddingS),
                _SharingSection(budgetId: _selectedBudgetId!),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _BudgetSelector extends StatelessWidget {
  const _BudgetSelector({
    required this.budgets,
    required this.selectedId,
    required this.onSelected,
  });

  final List<BudgetWithSpendingEntity> budgets;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.w,
      children: budgets.map((item) {
        final isSelected = item.budget.id == selectedId;
        return ChoiceChip(
          label: Text(
            item.categoryName,
            style: TextStyle(
              fontSize: 12.sp,
              color: isSelected ? Colors.white : null,
            ),
          ),
          selected: isSelected,
          selectedColor: AppColors.primary,
          onSelected: (_) => onSelected(item.budget.id),
        );
      }).toList(),
    );
  }
}

class _SharingSection extends StatelessWidget {
  const _SharingSection({required this.budgetId});

  final String budgetId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilesBloc, ProfilesState>(
      builder: (context, profileState) {
        if (profileState.status == ProfilesStatus.loading) {
          return const SkeletonListTileGroup(count: 3);
        }

        // Only show non-owner profiles
        final profiles =
            profileState.profiles.where((p) => !p.isOwner).toList();

        if (profiles.isEmpty) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                children: [
                  Icon(
                    Icons.person_add_outlined,
                    size: 40.w,
                    color: AppColors.disabled,
                  ),
                  SizedBox(height: AppDimensions.paddingS),
                  Text(
                    'No family members to share with',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  SizedBox(height: AppDimensions.paddingXS),
                  Text(
                    'Add family members in Settings first',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          );
        }

        return BlocBuilder<SharedBudgetsBloc, SharedBudgetsState>(
          builder: (context, shareState) {
            return Card(
              child: Column(
                children: profiles.map((profile) {
                  final isShared = shareState.isSharedWith(profile.id);
                  return _ProfileShareTile(
                    profile: profile,
                    budgetId: budgetId,
                    isShared: isShared,
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }
}

class _ProfileShareTile extends StatelessWidget {
  const _ProfileShareTile({
    required this.profile,
    required this.budgetId,
    required this.isShared,
  });

  final ProfileEntity profile;
  final String budgetId;
  final bool isShared;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: CircleAvatar(
        radius: 18.r,
        backgroundColor: Color(profile.avatarColor).withValues(alpha: 0.15),
        child: Text(
          profile.initials,
          style: TextStyle(
            color: Color(profile.avatarColor),
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
        ),
      ),
      title: Text(profile.name),
      subtitle: Text(
        isShared ? 'Has access (viewer)' : 'No access',
        style: TextStyle(
          fontSize: 12.sp,
          color: isShared ? AppColors.income : AppColors.disabled,
        ),
      ),
      value: isShared,
      onChanged: (value) {
        final bloc = context.read<SharedBudgetsBloc>();
        if (value) {
          bloc.add(BudgetShared(SharedBudgetEntity(
            id: const Uuid().v4(),
            budgetId: budgetId,
            profileId: profile.id,
            profileName: profile.name,
            accessLevel: AccessLevel.viewer,
          )));
        } else {
          bloc.add(BudgetUnshared(
            budgetId: budgetId,
            profileId: profile.id,
          ));
        }
      },
    );
  }
}

class _EmptyBudgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 64.w,
              color: AppColors.disabled,
            ),
            SizedBox(height: AppDimensions.paddingM),
            Text(
              'No budgets to share',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: AppDimensions.paddingS),
            Text(
              'Create budgets first, then share them here',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
