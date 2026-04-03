import 'package:finwise/core/navigation/app_routes.dart';
import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/category/domain/entities/category_entity.dart';
import 'package:finwise/features/category/presentation/bloc/category_bloc.dart';
import 'package:finwise/features/category/presentation/widgets/category_icon_widget.dart';
import 'package:finwise/shared/widgets/pill_tab_bar.dart';
import 'package:finwise/shared/widgets/skeleton_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:finwise/shared/widgets/app_icon.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingL,
              vertical: AppDimensions.paddingS,
            ),
            child: PillTabBar(
              selectedIndex: _selectedIndex,
              onChanged: (i) => setState(() => _selectedIndex = i),
              tabs: [
                PillTab(
                  label: 'Expense',
                  icon: HugeIcons.strokeRoundedArrowUp01,
                  activeColor: AppColors.expense,
                ),
                PillTab(
                  label: 'Income',
                  icon: HugeIcons.strokeRoundedArrowDown01,
                  activeColor: AppColors.income,
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state.status == CategoryStatus.loading) {
                  return const SkeletonListTileGroup(count: 4);
                }
                return IndexedStack(
                  index: _selectedIndex,
                  children: [
                    _CategoryList(categories: state.expenseCategories),
                    _CategoryList(categories: state.incomeCategories),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_categories',
        onPressed: () =>
            context.push(AppRoutes.settingsCategoryForm),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({required this.categories});

  final List<CategoryEntity> categories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(
              icon: HugeIcons.strokeRoundedDashboardSquare02,
              size: 48.w,
              color: theme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.4),
            ),
            SizedBox(height: AppDimensions.paddingM),
            Text(
              'No categories yet',
              style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.paddingL, AppDimensions.paddingS,
        AppDimensions.paddingL, 80.h,
      ),
      itemCount: categories.length,
      separatorBuilder: (_, __) => SizedBox(height: 8.h),
      itemBuilder: (context, index) =>
          _CategoryTile(category: categories[index]),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});

  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14.w, vertical: 4.h,
        ),
        leading: CategoryIconWidget(
          iconName: category.icon, color: category.color, size: 42,
        ),
        title: Text(
          category.name,
          style: theme.textTheme.bodyLarge
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: category.isDefault
            ? Text(
                'Default',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        trailing: category.isDefault
            ? null
            : IconButton(
                icon: AppIcon(icon: HugeIcons.strokeRoundedMoreVertical, size: 20.w),
                onPressed: () => _showOptions(context),
              ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bsCtx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36.w, height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 12.h),
              ListTile(
                leading: const AppIcon(icon: HugeIcons.strokeRoundedEdit02),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.of(bsCtx).pop();
                  context.push(
                    AppRoutes.settingsCategoryForm,
                    extra: category,
                  );
                },
              ),
              ListTile(
                leading: const AppIcon(
                  icon: HugeIcons.strokeRoundedDelete02,
                  color: AppColors.expense,
                ),
                title: const Text(
                  'Delete',
                  style: TextStyle(color: AppColors.expense),
                ),
                onTap: () {
                  Navigator.of(bsCtx).pop();
                  showDialog<void>(
                    context: context,
                    builder: (dCtx) => AlertDialog(
                      title: const Text('Delete Category'),
                      content: Text(
                        'Delete "${category.name}"?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dCtx).pop(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<CategoryBloc>().add(
                              CategoryDeleted(category.id),
                            );
                            Navigator.of(dCtx).pop();
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: AppColors.expense),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
